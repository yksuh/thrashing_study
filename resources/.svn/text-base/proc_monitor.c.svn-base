#define _GNU_SOURCE
#include <stdlib.h>
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
#define EXEC_PORT 7000
#define OUTPUT_FNAME "phantoms.dat"

static struct taskstats beforeMap[MAX_PROC_COUNT], afterMap[MAX_PROC_COUNT], stoppedMap[MAX_PROC_COUNT], threadMap[MAX_PROC_COUNT];
static int threadsBefore[MAX_PROC_COUNT], threadsAfter[MAX_PROC_COUNT];
static pthread_t listener;
static void ps_snap(struct taskstats *);
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
	ps_snap(beforeMap);
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

static void proc_diff(struct taskstats * t1, struct taskstats * t2, char * buf) {
	struct taskstats t;
	int pos;
	t = *t1;
        t.cpu_count 		-= t2->cpu_count;
        t.cpu_delay_total	-= t2->cpu_delay_total;
        t.blkio_count		-= t2->blkio_count;
        t.blkio_delay_total	-= t2->blkio_delay_total;
        t.swapin_count		-= t2->swapin_count;
        t.swapin_delay_total	-= t2->swapin_delay_total;
        t.cpu_run_real_total	-= t2->cpu_run_real_total;
      	t.cpu_run_virtual_total -= t2->cpu_run_virtual_total;
        t.ac_utime              -= t2->ac_utime;
        t.ac_stime              -= t2->ac_stime;
        t.ac_minflt		-= t2->ac_minflt;
        t.ac_majflt		-= t2->ac_majflt;
        t.read_char		-= t2->read_char;
        t.write_char		-= t2->write_char;
        t.read_syscalls		-= t2->read_syscalls;
	t.write_syscalls	-= t2->write_syscalls;
        t.read_bytes            -= t2->read_bytes;
        t.write_bytes           -= t2->write_bytes;
        t.nvcsw                 -= t2->nvcsw;
        t.nivcsw                -= t2->nivcsw;
        t.ac_utimescaled        -= t2->ac_utimescaled;
        t.ac_stimescaled        -= t2->ac_stimescaled;
        t.cpu_scaled_run_real_total  -= t2->cpu_scaled_run_real_total;
        t.freepages_count	-= t2->freepages_count;
        t.freepages_delay_total -= t2->freepages_delay_total;

	pos = 0;

	pos += sprintf(buf, "%05d(\t%s,\n\tbtime  :%llu,\n\tetime  :%llu,\n", t.ac_pid, t.ac_comm, t.ac_btime, t.ac_etime/1000);
	if (t.ac_minflt != 0)
		pos += sprintf(buf+pos, "\tmin_flt:%llu to %llu = %llu,\n", t2->ac_minflt, t1->ac_minflt, t.ac_minflt);
	if (t.ac_majflt != 0) 
		pos += sprintf(buf+pos, "\tmaj_flt:%llu to %llu = %llu,\n", t2->ac_majflt, t1->ac_majflt, t.ac_majflt);
	if (t.ac_utime != 0)
		pos += sprintf(buf+pos, "\tuTime  :%llu to %llu = %llu,\n", t2->ac_utime, t1->ac_utime, t.ac_utime);
	if (t.ac_stime != 0)
		pos += sprintf(buf+pos, "\tsTime  :%llu to %llu = %llu,\n", t2->ac_stime, t1->ac_stime, t.ac_stime);
	if (t.read_char != 0)
		pos += sprintf(buf+pos, "\tr_chr  :%llu to %llu = %llu,\n", t2->read_char, t1->read_char, t.read_char);
	if (t.write_char != 0)
		pos += sprintf(buf+pos, "\tw_chr  :%llu to %llu = %llu,\n", t2->write_char, t1->write_char, t.write_char);
	if (t.read_syscalls != 0)
		pos += sprintf(buf+pos, "\tr_calls:%llu to %llu = %llu,\n", t2->read_syscalls, t1->read_syscalls, t.read_syscalls);
	if (t.write_syscalls != 0)
		pos += sprintf(buf+pos, "\tw_calls:%llu to %llu = %llu,\n", t2->write_syscalls, t1->write_syscalls, t.write_syscalls);
	if (t.read_bytes != 0)
		pos += sprintf(buf+pos, "\tr_bytes:%llu to %llu = %llu,\n", t2->read_bytes, t1->read_bytes, t.read_bytes);
	if (t.write_bytes != 0)
		pos += sprintf(buf+pos, "\tw_bytes:%llu to %llu = %llu,\n", t2->write_bytes, t1->write_bytes, t.write_bytes);
	if (t.nvcsw != 0)
		pos += sprintf(buf+pos, "\tnvcsw  :%llu to %llu = %llu,\n", t2->nvcsw, t1->nvcsw, t.nvcsw);
	if (t.nivcsw != 0)
		pos += sprintf(buf+pos, "\tnivcsw :%llu to %llu = %llu,\n", t2->nivcsw, t1->nivcsw, t.nivcsw);
	if (t.ac_utimescaled != 0)
		pos += sprintf(buf+pos, "\tuTimeS :%llu to %llu = %llu,\n", t2->ac_utimescaled, t1->ac_utimescaled, t.ac_utimescaled);
	if (t.ac_stimescaled != 0)
		pos += sprintf(buf+pos, "\tsTimeS :%llu to %llu = %llu,\n", t2->ac_stimescaled, t1->ac_stimescaled, t.ac_stimescaled);
	if (t.cpu_scaled_run_real_total != 0)
		pos += sprintf(buf+pos, "\tcpu_reS:%llu to %llu = %llu,\n", t2->cpu_scaled_run_real_total/1000, t1->cpu_scaled_run_real_total/1000, t.cpu_scaled_run_real_total/1000);
	if (t.freepages_count != 0)
		pos += sprintf(buf+pos, "\tfreePgs:%llu to %llu = %llu,\n", t2->freepages_count, t1->freepages_count, t.freepages_count);
	if (t.freepages_delay_total != 0)
		pos += sprintf(buf+pos, "\tfreePgD:%llu to %llu = %llu,\n", t2->freepages_delay_total/1000, t1->freepages_delay_total/1000, t.freepages_delay_total/1000);
	if (t.cpu_count != 0)
		pos += sprintf(buf+pos, "\tcpuCnt :%llu to %llu = %llu,\n", t2->cpu_count, t1->cpu_count, t.cpu_count);
	if (t.cpu_delay_total != 0)
		pos += sprintf(buf+pos, "\tcpuDel :%llu to %llu = %llu,\n", t2->cpu_delay_total/1000, t1->cpu_delay_total/1000, t.cpu_delay_total/1000);
	if (t.blkio_count != 0)
		pos += sprintf(buf+pos, "\tblkCnt :%llu to %llu = %llu,\n", t2->blkio_count, t1->blkio_count, t.blkio_count);
	if (t.blkio_delay_total != 0)
		pos += sprintf(buf+pos, "\tblkDel :%llu to %llu = %llu,\n", t2->blkio_delay_total/1000, t1->blkio_delay_total/1000, t.blkio_delay_total/1000);
	if (t.swapin_count != 0)
		pos += sprintf(buf+pos, "\tswpCnt :%llu to %llu = %llu,\n", t2->swapin_count, t1->swapin_count, t.swapin_count);
	if (t.swapin_delay_total != 0)
		pos += sprintf(buf+pos, "\tswpDel :%llu to %llu = %llu,\n", t2->swapin_delay_total/1000, t1->swapin_delay_total/1000, t.swapin_delay_total/1000);
        if (t.cpu_run_real_total != 0)
		pos += sprintf(buf+pos, "\tcpu_reT:%llu to %llu = %llu,\n", t2->cpu_run_real_total/1000, t1->cpu_run_real_total/1000, t.cpu_run_real_total/1000);
	if (t.cpu_run_virtual_total != 0)
		pos += sprintf(buf+pos, "\tcpu_rvT:%llu to %llu = %llu,\n", t2->cpu_run_virtual_total/1000, t1->cpu_run_virtual_total/1000, t.cpu_run_virtual_total/1000);
	sprintf(buf+pos, ")\n");
}


static void stop_timing(int sockfd) {
    
	int i;
	char buf[1800]; 

	ps_snap(afterMap);

	pthread_cancel(listener);
	
	for (i = 0; i < MAX_PROC_COUNT; i++) {
		if (beforeMap[i].ac_pid == 0 && afterMap[i].ac_pid == 0 && stoppedMap[i].ac_pid == 0)
			continue;
		bzero(buf, 1800);

		if (afterMap[i].ac_pid != 0) {
			proc_diff(&afterMap[i], &beforeMap[i], buf);
		} else if (stoppedMap[i].ac_pid != 0) {
			proc_diff(&stoppedMap[i], &beforeMap[i], buf);
		}
		send(sockfd, buf, strlen(buf), 0);
	}
	bzero(buf, 1800);
	sprintf(buf, "\nEND\n");
	send(sockfd, buf, 5, 0);
	shutdown(sockfd, SHUT_WR);
	recv(sockfd, buf, 3, 0);
	close(sockfd);
	bzero(beforeMap, sizeof(struct taskstats) * MAX_PROC_COUNT);
	bzero(afterMap, sizeof(struct taskstats) * MAX_PROC_COUNT);
	bzero(stoppedMap, sizeof(struct taskstats) * MAX_PROC_COUNT);
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

static void process_snap(struct taskstats * sto, int pid, struct nl_sock * sock, struct nl_msg *msg) {
	
	bzero(threadMap, sizeof(struct taskstats)*MAX_PROC_COUNT);
	bzero(threadsBefore, sizeof(int)*MAX_PROC_COUNT);
	bzero(threadsAfter, sizeof(int)*MAX_PROC_COUNT);
	//list threads
	list_threads(pid, threadsBefore);

	// read stats per-thread
	int thread_num = -1;
	while (threadsBefore[++thread_num] != 0) {
		if (threadsBefore[thread_num] == pid)
			continue;
		get_stat(sock, msg, pid, &(threadMap[threadsBefore[thread_num]]), TASKSTATS_CMD_ATTR_PID);
	}
	
	// read overall
	get_stat(sock, msg, pid, sto, TASKSTATS_CMD_ATTR_TGID);
	get_stat(sock, msg, pid, sto, TASKSTATS_CMD_ATTR_PID);

	// list threads again
	list_threads(pid, threadsAfter);

	// add those threads that are still alive
	thread_num = -1;
	int tid = 0;
	while ((tid = threadsAfter[++thread_num]) != 0) {
		// if doesn't exist anymore
		if (tid == pid)
			continue;
		// if still exists
		taskstats_plus(sto, &(threadMap[tid]));

	}
}

static void ps_snap(struct taskstats * sto) {
	struct nl_sock *sock = NULL;
	struct nl_msg *msg = NULL;
	DIR *procDir;

	if (!(procDir = opendir("/proc"))) {
		perror("/proc");
		return;
	}

	init_ts(&sock, &msg);

	while(1) {
		struct dirent * entry;
		entry = readdir (procDir);
		if (! entry)
			break;
		int pid = 0;
		if (sscanf(entry->d_name, "%d", &pid) > 0)
				process_snap(&(sto[pid]), pid, sock, msg);
	}

	nl_close(sock);
	nl_socket_free(sock);
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
		store->ac_gid 			= stats->ac_gid;
		strcpy(store->ac_comm, stats->ac_comm);
		store->ac_etime 		= stats->ac_etime;
		store->ac_btime 		= stats->ac_btime;
		store->ac_pid			= stats->ac_pid;
		store->ac_utime			= stats->ac_utime;
		store->ac_stime			= stats->ac_stime;
		store->ac_minflt		= stats->ac_minflt;
		store->ac_majflt		= stats->ac_majflt;
		store->read_char		= stats->read_char;
		store->write_char		= stats->write_char;
		store->read_syscalls	= stats->read_syscalls;
		store->write_syscalls	= stats->write_syscalls;
		store->read_bytes		= stats->read_bytes;
		store->write_bytes		= stats->write_bytes;
		store->ac_utimescaled	= stats->ac_utimescaled;
		store->ac_stimescaled	= stats->ac_stimescaled;
	}
}
