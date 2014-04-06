#define _GNU_SOURCE
#include <stdlib.h>
#include <stdio.h>
#include <strings.h>
#include <unistd.h>

#include <sys/socket.h>
#include <sys/types.h>
#include <errno.h>
#include <linux/taskstats.h>

#include <pthread.h>
#include <signal.h>
#include <dirent.h>

#include <netlink/netlink.h>
#include <netlink/genl/genl.h>
#include <netlink/genl/ctrl.h>

#define MAX_PROC_COUNT 32768
#define MAX_PROCINFO_LEN 8192
#define EXEC_PORT 7000
#define OUTPUT_FNAME "phantoms.dat"

static struct taskstats stoppedMap[MAX_PROC_COUNT], threadMap[MAX_PROC_COUNT];
static int threads[MAX_PROC_COUNT];
static char beforeMap[MAX_PROC_COUNT][MAX_PROCINFO_LEN], afterMap[MAX_PROC_COUNT][MAX_PROCINFO_LEN];
static pthread_t listener;
static void ps_snap(char *);
static void get_stat(struct nl_sock *, struct nl_msg *, int, struct taskstats *, int);
static void sig_handler(int);
static void init_ts(struct nl_sock **, struct nl_msg **);
static void * listen_exits(void *);
static int cmpstats(const void *, const void *);
static int callback_message (struct nl_msg *, void *);
static int callback_listens (struct nl_msg *, void *);
static void send_rdy(int);
static void init_exec_sock(int *);
static int start_timing(int, struct nl_sock **);
static void stop_timing(int);
static void init_timing(int);

static int sockfd;
static char* port;

void sig_handler(int sig) {
	close(sockfd);
	exit(0);
}

int main (int argc, char ** argv) {

	memset(beforeMap, 0, sizeof(char) * MAX_PROC_COUNT * MAX_PROCINFO_LEN);
	memset(afterMap, 0, sizeof(char) * MAX_PROC_COUNT * MAX_PROCINFO_LEN);
	bzero(stoppedMap, MAX_PROC_COUNT);

	signal(SIGTERM, sig_handler);
	if (argc > 1)
		port = argv[1];
	else
		port = "7000";

	init_exec_sock(&sockfd);

	init_timing(sockfd);

	return 0;
}

static void init_exec_sock(int *sockfd) {
	struct addrinfo hints, *res;

	memset(&hints, 0, sizeof(hints));

	hints.ai_family = AF_UNSPEC;
	hints.ai_socktype = SOCK_STREAM;
	hints.ai_flags = AI_PASSIVE;

	getaddrinfo(NULL, port, &hints, &res);

	*sockfd = socket(AF_INET, SOCK_STREAM, 0);

	if (bind(*sockfd, res->ai_addr, res->ai_addrlen) == -1) {
		perror("bind");
	}
}

static void init_timing(int sockfd) {
	int sig_sock;
	struct nl_sock *nlsock;
	listen(sockfd, 1);

	while(1) {
		sig_sock = start_timing(sockfd, &nlsock);
		stop_timing(sig_sock);
		nl_close(nlsock);
		nl_socket_free(nlsock);
	}
}

static int start_timing(int sockfd, struct nl_sock **nlsock) {
	struct sockaddr_storage client_addr;
	socklen_t addr_size;
	int sig_sock;

	sig_sock = accept(sockfd, (struct sockaddr *) &client_addr, &addr_size);
	pthread_create(&listener, NULL, listen_exits, nlsock);
	ps_snap(&beforeMap[0][0]);
	send_rdy(sig_sock);
	char buf[256];
	if (recv(sig_sock, buf, sizeof(buf), 0) == -1) {
		perror("recv");
	}
	return sig_sock;
}

static void send_rdy(int sockfd) {
	send(sockfd, "ACK", 3, 0);
}

static void proc_map(struct taskstats * t, char * buf) {

	int pos = 0;

	pos += sprintf(buf, "%05d(\t%s,\n\tbtime  :%llu,\n\tetime  :%llu,\n", t->ac_pid, t->ac_comm, t->ac_btime, t->ac_etime);
	if (t->ac_minflt != 0)
		pos += sprintf(buf+pos, "\tmin_flt:%llu,\n", t->ac_minflt);
	if (t->ac_majflt != 0) 
		pos += sprintf(buf+pos, "\tmaj_flt:%llu,\n", t->ac_majflt);
	if (t->ac_utime != 0)
		pos += sprintf(buf+pos, "\tuTime  :%llu,\n", t->ac_utime);
	if (t->ac_stime != 0)
		pos += sprintf(buf+pos, "\tsTime  :%llu,\n", t->ac_stime);
	if (t->read_char != 0)
		pos += sprintf(buf+pos, "\tr_chr  :%llu,\n", t->read_char);
	if (t->write_char != 0)
		pos += sprintf(buf+pos, "\tw_chr  :%llu,\n", t->write_char);
	if (t->read_syscalls != 0)
		pos += sprintf(buf+pos, "\tr_calls:%llu,\n", t->read_syscalls);
	if (t->write_syscalls != 0)
		pos += sprintf(buf+pos, "\tw_calls:%llu,\n", t->write_syscalls);
	if (t->read_bytes != 0)
		pos += sprintf(buf+pos, "\tr_bytes:%llu,\n", t->read_bytes);
	if (t->write_bytes != 0)
		pos += sprintf(buf+pos, "\tw_bytes:%llu,\n", t->write_bytes);
	if (t->nvcsw != 0)
		pos += sprintf(buf+pos, "\tnvcsw  :%llu,\n", t->nvcsw);
	if (t->nivcsw != 0)
		pos += sprintf(buf+pos, "\tnivcsw :%llu,\n", t->nivcsw);
	if (t->ac_utimescaled != 0)
		pos += sprintf(buf+pos, "\tuTimeS :%llu,\n", t->ac_utimescaled);
	if (t->ac_stimescaled != 0)
		pos += sprintf(buf+pos, "\tsTimeS :%llu,\n", t->ac_stimescaled);
	if (t->cpu_scaled_run_real_total != 0)
		pos += sprintf(buf+pos, "\tcpu_reS:%llu,\n", t->cpu_scaled_run_real_total);
	if (t->freepages_count != 0)
		pos += sprintf(buf+pos, "\tfreePgs:%llu,\n", t->freepages_count);
	if (t->freepages_delay_total != 0)
		pos += sprintf(buf+pos, "\tfreePgD:%llu,\n", t->freepages_delay_total);
	if (t->cpu_count != 0)
		pos += sprintf(buf+pos, "\tcpuCnt :%llu,\n", t->cpu_count);
	if (t->cpu_delay_total != 0)
		pos += sprintf(buf+pos, "\tcpuDel :%llu,\n", t->cpu_delay_total);
	if (t->blkio_count != 0)
		pos += sprintf(buf+pos, "\tblkCnt :%llu,\n", t->blkio_count);
	if (t->blkio_delay_total != 0)
		pos += sprintf(buf+pos, "\tblkDel :%llu,\n", t->blkio_delay_total);
	if (t->swapin_count != 0)
		pos += sprintf(buf+pos, "\tswpCnt :%llu,\n", t->swapin_count);
	if (t->swapin_delay_total != 0)
		pos += sprintf(buf+pos, "\tswpDel :%llu,\n", t->swapin_delay_total);
        if (t->cpu_run_real_total != 0)
		pos += sprintf(buf+pos, "\tcpu_reT:%llu,\n", t->cpu_run_real_total);
	if (t->cpu_run_virtual_total != 0)
		pos += sprintf(buf+pos, "\tcpu_rvT:%llu,\n", t->cpu_run_virtual_total);
	pos += sprintf(buf+pos, "\tppid: %d\n", t->ac_ppid);
	pos += sprintf(buf+pos, "\tgid: %d\n", t->ac_gid);
	sprintf(buf+pos, ")\n");
}


static void stop_timing(int sockfd) {
    
	int i;
	char buf[1800]; 

	ps_snap(&afterMap[0][0]);

	pthread_cancel(listener);

	send(sockfd, "BEFORE:\n", 8, 0); 
	for (i = 0; i < MAX_PROC_COUNT; i++)
		if (beforeMap[i][0] != 0)
			send(sockfd, beforeMap[i], strlen(beforeMap[i]), 0);

	send(sockfd, "AFTER:\n", 7, 0); 
	for (i = 0; i < MAX_PROC_COUNT; i++)
		if (afterMap[i][0] != 0) 
			send(sockfd, beforeMap[i], strlen(beforeMap[i]), 0);

	send(sockfd, "STOPPED:\n", 9, 0); 
	for (i = 0; i < MAX_PROC_COUNT; i++) {
		if (stoppedMap[i].ac_pid == 0) continue;
		bzero(buf, 1800);
		proc_map(stoppedMap+i, buf);
		send(sockfd, buf, strlen(buf), 0);
	}
	bzero(buf, 1800);
	sprintf(buf, "\nEND\n");
	send(sockfd, buf, 5, 0);
	shutdown(sockfd, SHUT_WR);
	recv(sockfd, buf, 3, 0);
	close(sockfd);
	memset(beforeMap, 0, sizeof(char) * MAX_PROC_COUNT * MAX_PROCINFO_LEN);
	memset(afterMap, 0, sizeof(char) * MAX_PROC_COUNT * MAX_PROCINFO_LEN);
	bzero(stoppedMap, MAX_PROC_COUNT);
}

static void taskstats_plus(struct taskstats *sto, struct taskstats *add) {
	sto->ac_utime		+= add->ac_utime;
	sto->ac_stime		+= add->ac_stime;
	sto->ac_minflt		+= add->ac_minflt;
	sto->ac_majflt		+= add->ac_majflt;
	sto->read_char		+= add->read_char;
	sto->write_char		+= add->write_char;
	sto->read_syscalls	+= add->read_syscalls;
	sto->write_syscalls	+= add->write_syscalls;
	sto->read_bytes		+= add->read_bytes;
	sto->write_bytes	+= add->write_bytes;
	sto->ac_utimescaled	+= add->ac_utimescaled;
	sto->ac_stimescaled	+= add->ac_stimescaled;
}

static void list_threads(int pid, int* threads) {

	DIR *procDir;
	char dir_name[256];
	sprintf(dir_name, "/proc/%d/task", pid);
	if (!(procDir = opendir(dir_name))) {
		perror(dir_name);
		return;
	}

	int thread_count = 0;
	while(1){
		struct dirent * entry;
		entry = readdir (procDir);
		if (! entry)
			break;
		int pid = 0;
		if (sscanf(entry->d_name, "%d", &pid) > 0) {
			threads[thread_count] = pid;
			thread_count++;
		}
	}
	closedir(procDir);
}

static void process_snap_proc(char* sto, int pid, int tid) {
	// read /proc/[pid]/stat
	FILE * pFile;
	char fname[256];
	bzero(fname, 256);
	sprintf(fname, "/proc/%d/task/%d/stat", pid, tid);
	pFile = fopen (fname,"r");
	char stat[MAX_PROCINFO_LEN];
	{ 
		char buf[1024];
		bzero(buf, 1024);
		int cur = 0;
		while(fgets(buf, 1024, pFile)) {
			sprintf(stat+cur, "%s", buf);
			cur += strlen(buf);
			bzero(buf, 1024);
		}
	}
	fclose(pFile);

	// read /proc/[pid]/status
	bzero(fname, 256);
	sprintf(fname, "/proc/%d/task/%d/status", pid, tid);
	pFile = fopen (fname,"r");
	char status[MAX_PROCINFO_LEN];
	{ 
		char buf[1024];
		bzero(buf, 1024);
		int cur = 0;
		while(fgets(buf, 1024, pFile)) {
			sprintf(status+cur, "%s", buf);
			cur += strlen(buf);
			bzero(buf, 1024);
		}
	}
	fclose(pFile);

	// and /proc/[pid]/io
	bzero(fname, 256);
	sprintf(fname, "/proc/%d/task/%d/io", pid, tid);
	pFile = fopen (fname,"r");
	char io[MAX_PROCINFO_LEN];
	{ 
		char buf[1024];
		bzero(buf, 1024);
		int cur = 0;
		while(fgets(buf, 1024, pFile)) {
			sprintf(io+cur, "%s", buf);
			cur += strlen(buf);
			bzero(buf, 1024);
		}
	}
	fclose(pFile);
	memset(sto, 0, MAX_PROCINFO_LEN);
	sprintf(sto, "%d:%d\nstat\n%s\nstatus\n%s\nio\n%s\n", pid, tid, stat, status, io);
}

static void ps_snap(char* sto) {
	//struct nl_sock *sock = NULL;
	//struct nl_msg *msg = NULL;
	DIR *procDir;

	if (!(procDir = opendir("/proc"))) {
		perror("/proc");
		return;
	}

	//init_ts(&sock, &msg);

	while(1) {
		struct dirent * entry;
		entry = readdir (procDir);
		if (! entry)
			break;
		int pid = 0;
		if (sscanf(entry->d_name, "%d", &pid) > 0) {
			list_threads(pid, threads);
			int i = -1; 
			while (threads[++i] != 0) {
				process_snap_proc(sto + threads[i]*MAX_PROCINFO_LEN, pid, threads[i]);//, sock, msg);
			}
			memset(threads, 0, MAX_PROC_COUNT);
		}
	}

	//nl_close(sock);
	//nl_socket_free(sock);
	closedir(procDir);
}

static void *listen_exits(void * arg) {
	struct nl_sock **sock = (struct nl_sock **)arg;
	struct nl_msg *msg = NULL;
	init_ts(sock, &msg);
	// specify a callback for inbound messages
	nl_socket_modify_cb(*sock, NL_CB_MSG_IN, NL_CB_CUSTOM, callback_listens, stoppedMap);

	nla_put_string(msg, TASKSTATS_CMD_ATTR_REGISTER_CPUMASK, "0");
	nl_send_auto(*sock, msg);
	nl_wait_for_ack(*sock);

	for (;;) {
		nl_recvmsgs_default(*sock);
	}
    
    	return *sock;
}

static void get_stat(struct nl_sock *sock, struct nl_msg *msg, int pid, struct taskstats * sto, int cmd) {
    
	// specify a callback for inbound messages
	nl_socket_modify_cb(sock, NL_CB_MSG_IN, NL_CB_CUSTOM, callback_message, sto);
    
	nla_put_u32(msg, cmd, pid);
	nl_send_auto(sock, msg);
	nl_wait_for_ack(sock);
	nl_recvmsgs_default(sock);
}

static void init_ts(struct nl_sock **sock, struct nl_msg **msg) {
	int family;
	
	*sock = nl_socket_alloc();
    
	// Connect to generic netlink socket on kernel side
	genl_connect(*sock);

	nl_socket_set_buffer_size(*sock, 5242880, 0);
    
	// get the id for the TASKSTATS generic family
	family = genl_ctrl_resolve(*sock, "TASKSTATS");
    
	// register for task exit events
	*msg = nlmsg_alloc();
    
	genlmsg_put(*msg, NL_AUTO_PID, NL_AUTO_SEQ, family, 0, 0, TASKSTATS_CMD_GET, TASKSTATS_VERSION);
}

static int cmpstats(const void *p1, const void *p2) {
	const struct taskstats *s1 = p1, *s2 = p2;
	return ( (s1->ac_pid - s2->ac_pid) == 0
                ? s1->ac_etime - s2->ac_etime
                : s1->ac_pid - s2->ac_pid );
}

static int callback_listens (struct nl_msg * nlmsg, void * sto) {
	struct nlmsghdr *	nlhdr;
	struct nlattr *		nlattrs[TASKSTATS_TYPE_MAX+1];
	struct nlattr *		nlattr;
	struct taskstats *	stats;
	struct taskstats *	store;
	int rem = 1;

	store = (struct taskstats *) sto;

	nlhdr = nlmsg_hdr(nlmsg);

	// validate message and parse attributes
	genlmsg_parse(nlhdr, 0, nlattrs, TASKSTATS_TYPE_MAX, 0);

	if ((nlattr = nlattrs[TASKSTATS_TYPE_AGGR_TGID]) || (nlattr = nlattrs[TASKSTATS_TYPE_AGGR_PID])) {
		stats = nla_data(nla_next(nla_data(nlattr), &rem));
		int pid = *(int*)nla_data(nla_data(nlattr));
		store[pid].ac_pid = pid;
		callback_message(nlmsg, &(store[pid]));
	}
}

static int callback_message (struct nl_msg * nlmsg, void * sto) {
	struct nlmsghdr *	nlhdr;
	struct nlattr *		nlattrs[TASKSTATS_TYPE_MAX+1];
	struct nlattr *		nlattr;
	struct taskstats *	stats;
	struct taskstats *	store;
	int rem = 1;

	nlhdr = nlmsg_hdr(nlmsg);

	store = (struct taskstats *) sto;

	// validate message and parse attributes
	genlmsg_parse(nlhdr, 0, nlattrs, TASKSTATS_TYPE_MAX, 0);


	if ((nlattr = nlattrs[TASKSTATS_TYPE_AGGR_TGID])) {
		stats = nla_data(nla_next(nla_data(nlattr), &rem));
		*store = *stats;
	}

	if ((nlattr = nlattrs[TASKSTATS_TYPE_AGGR_PID])) {
		stats = nla_data(nla_next(nla_data(nlattr), &rem));
		*store = *stats;
	}
}
