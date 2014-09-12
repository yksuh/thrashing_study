**
Note: regarding xlock ratios of .25, .50, .75, the update transactions are not correct. In the confirmatory, lets fix that.
Basically, every batchset with .25, .50. or .75 ratios needs to be fixed.
Before proceeding with confirmatory, lets update transactions for such batchsets.
Read is fine.


select ex.experimentname , bs.batchsetid as bsid, bs.xlockratio as xr, bs.effectivedbsz as arp, t.transactionstr 
from 
azdblab_experiment ex,
azdblab_batchset bs,
azdblab_batch b,
azdblab_client c, 
azdblab_transaction t 
where 
      ex.experimentid = bs.experimentid
  and bs.batchsetid = b.batchsetid 
  and b.batchid = c.batchid
  and c.clientid = t.clientid
  and c.clientnum = 1
  and ex.experimentname like '%-120-%'
  and b.mpl = 100 
  and bs.xactsz = 0 
order by bs.batchsetid, b.batchid, c.clientnum


EXPERIMENTNAME		BSID	XR	ARP	TRANSACTIONSTR
xt-30K-1000-120-1	1	0	.25	UPDATE ft_HT2 SET id5 = 15376  WHERE id1 >= 3690 and id1 < 3990
xt-30K-1000-120-1	2	0	.5	UPDATE ft_HT1 SET id2 = 2663  WHERE id1 >= 1305 and id1 < 1605
xt-30K-1000-120-1	21	0	.75	UPDATE ft_HT2 SET val2 = "4O2YvFjoS7NaFuGwfRjtL6FPsATGMCiSrHyuaSXNnVnXPasSEzLQw3yVigWcpReiuabaiSUcJsCaNkTO5Z5cttcA"  WHERE id1 >= 20908 and id1 < 21208
xt-30K-1000-120-1	22	0	1	UPDATE ft_HT2 SET id5 = 18896  WHERE id1 >= 18707 and id1 < 19007
xt-30K-1000-120-1	41	.25	.25	UPDATE ft_HT1 SET id4 = 14885  WHERE id1 >= 3572 and id1 < 3872
xt-30K-1000-120-1	42	.25	.5	UPDATE ft_HT2 SET val1 = "PDw74tQDVJPZ0oJW5Aw4nYrKvYBsfbAcQMd7SlHxIfsrsUP4gy51NxfbN7OinOlVj7siWZPMHqobO1X5DH0ClOvOZz"  WHERE id1 >= 10285 and id1 < 10585
xt-30K-1000-120-1	61	.25	.75	UPDATE ft_HT1 SET id2 = 857  WHERE id1 >= 634 and id1 < 934
xt-30K-1000-120-1	62	.25	1	UPDATE ft_HT2 SET val2 = "HCaFqOsY3ZzWYmP4cHDTgDiTRYDkqnImEZ15GXjtLnQBume5rRKLstmMzpCKL2nDnYVGZbZZ5aQThIfhGkTGeqUlxD"  WHERE id1 >= 26538 and id1 < 26838
xt-30K-1000-120-1	81	.5	.25	UPDATE ft_HT1 SET id4 = 14618  WHERE id1 >= 3508 and id1 < 3808
xt-30K-1000-120-1	101	.5	.5	UPDATE ft_HT1 SET id4 = 12021  WHERE id1 >= 5890 and id1 < 6190
xt-1M-1000-120-2	102	0	.25	UPDATE ft_HT1 SET id4 = 480124  WHERE id1 >= 115230 and id1 < 125230
xt-30K-1000-120-1	121	.5	.75	UPDATE ft_HT2 SET val2 = "BRORgulZbDY3qEX6KeycXbwpjtw3Q7VhZiBcSwUJCkLNOsOzzjvUAH5p0ByQQATut1VOVf1QeIDxxlv2UT7fkVcEDO"  WHERE id1 >= 19525 and id1 < 19825
xt-30K-1000-120-1	141	.5	1	UPDATE ft_HT1 SET id4 = 11865  WHERE id1 >= 11746 and id1 < 12046
xt-30K-1000-120-1	142	.75	.25	UPDATE ft_HT1 SET id3 = 8685  WHERE id1 >= 2084 and id1 < 2384
xt-30K-1000-120-1	143	.75	.5	UPDATE ft_HT2 SET val2 = "n2tG3yZxwNL6DF6cikOjsgZYphmbHgzc3iiv0wAFIJRus4QcWU2G1qDCQqSsqe3WFHogAf0hxAWaCilAX2RGMiK31"  WHERE id1 >= 13517 and id1 < 13817
xt-30K-1000-120-1	161	.75	.75	UPDATE ft_HT1 SET id2 = 544  WHERE id1 >= 402 and id1 < 702
xt-30K-1000-120-1	162	.75	1	UPDATE ft_HT2 SET val1 = "cEfgaGJnHO3idit26jxXVbOuxwzCTu0fAy0ymoNFSRIuCAomsArOSnCRk33ARlmCRaMtpQWyzaTUEthgimCsrPtJ"  WHERE id1 >= 24600 and id1 < 24900
xt-30K-1000-120-1	181	1	.25	UPDATE ft_HT1 SET id2 = 1282  WHERE id1 >= 307 and id1 < 607
xt-30K-1000-120-1	182	1	.5	UPDATE ft_HT2 SET id5 = 18809  WHERE id1 >= 9216 and id1 < 9516
xt-30K-1000-120-1	201	1	.75	UPDATE ft_HT1 SET id3 = 7418  WHERE id1 >= 5489 and id1 < 5789
xt-30K-1000-120-1	221	1	1	UPDATE ft_HT1 SET id3 = 8080  WHERE id1 >= 7999 and id1 < 8299
xt-1M-1000-120-2	282	0	.5	UPDATE ft_HT2 SET id5 = 633445  WHERE id1 >= 310388 and id1 < 320388
xt-1M-1000-120-2	322	0	.75	UPDATE ft_HT1 SET id2 = 43681  WHERE id1 >= 32324 and id1 < 42324
xt-1M-1000-120-2	361	0	1	UPDATE ft_HT2 SET val2 = "uAqaRUVnx6LbCBKejsiqW7Z5UEGeQd3DudlGsrfKWfZeMPcFsX54EAbEmKT3nAzM7IEs3GO0NBqMp1sDrH7c6Kfg1"  WHERE id1 >= 961243 and id1 < 971243
xt-1M-1000-120-2	401	.25	.25	UPDATE ft_HT1 SET id2 = 95151  WHERE id1 >= 22836 and id1 < 32836
xt-1M-1000-120-2	422	.25	.5	UPDATE ft_HT2 SET val1 = "RSyKFlosy0krmf4jSoPdnc5lEfaWy2DPtIgIcxiBxzRmqvVffmwuibhNb631FaD1ZspaMItiMlZEw7pcqajQwn5dT"  WHERE id1 >= 333703 and id1 < 343703
xt-1M-1000-120-2	462	.25	.75	UPDATE ft_HT1 SET id3 = 211032  WHERE id1 >= 156163 and id1 < 166163
xt-1M-1000-120-2	482	.25	1	UPDATE ft_HT2 SET id5 = 662044  WHERE id1 >= 655423 and id1 < 665423
xt-1M-1000-120-2	521	.5	.25	UPDATE ft_HT2 SET val1 = "OWywbAjWjvtHejfwHNeuCjRmJ0ThYngpBJuZOaZ1IiiivN5ssLASIK7eFGZBMpkEsbmSqfUbgr4YJbzkpaJhCNHb"  WHERE id1 >= 167321 and id1 < 177321
xt-1M-1000-120-2	542	.5	.5	UPDATE ft_HT1 SET id4 = 419839  WHERE id1 >= 205721 and id1 < 215721
xt-1M-1000-120-2	582	.5	.75	UPDATE ft_HT2 SET val2 = "UXhuj0k0IlgaBaWdUyghfJSsdwALzA43RreVg3WANQDPROp7YHyyP1zrmXI4DiIPRmYgV5K5RY6VzJIM16e3Pj0CS"  WHERE id1 >= 689715 and id1 < 699715
xt-1M-1000-120-2	601	.5	1	UPDATE ft_HT2 SET val1 = "TRscsRQDKQ74nXrPEYp1RhitZZFycm0R1JDmeEOJSq1yVCe4OI2XRNMFa4kgbJdzPxAfGFqUY33vpyEJgOWz1Bsu"  WHERE id1 >= 744689 and id1 < 754689
xt-1M-1000-120-2	641	.75	.25	UPDATE ft_HT1 SET id3 = 180195  WHERE id1 >= 43247 and id1 < 53247
xt-1M-1000-120-2	662	.75	.5	UPDATE ft_HT2 SET val2 = "UBXrl3ic4npSScYbdMhCmCRZsMZQNwMxAhG3cEpII5mEjXztPHwa71wZereDpN7DNcHm3dtnW3ZdzwH6csqiQopV"  WHERE id1 >= 464581 and id1 < 474581
xt-1M-1000-120-2	702	.75	.75	UPDATE ft_HT2 SET val2 = "tcK0zakPlWUnGvYQbysDtbdhyyeD0kr6rLkKfzlN0uHowIJ62x7n6oaGr5ycQbVY20KRIC3Y6bUci5ySUYscjuGyr0"  WHERE id1 >= 714316 and id1 < 724316
xt-1M-1000-120-2	741	.75	1	UPDATE ft_HT2 SET id5 = 653979  WHERE id1 >= 647439 and id1 < 657439
xt-1M-1000-120-2	762	1	.25	UPDATE ft_HT1 SET id3 = 280184  WHERE id1 >= 67244 and id1 < 77244
xt-1M-1000-120-2	802	1	.5	UPDATE ft_HT2 SET val1 = "YZXdjt6UFVmistBo7Tes0WJmdaxMeKcZ30hafzrmpPYDARJc2ooVIJ0AZ0CepnB7TXFmxEinMUoDvRsEePYjvSMqnj"  WHERE id1 >= 396543 and id1 < 406543
xt-1M-1000-120-2	841	1	.75	UPDATE ft_HT1 SET id2 = 161264  WHERE id1 >= 119335 and id1 < 129335
xt-1M-1000-120-2	862	1	1	UPDATE ft_HT1 SET id3 = 303990  WHERE id1 >= 300950 and id1 < 310950
xt-1M-1000-120-1	1602	.25	.25	UPDATE ft_HT2 SET id5 = 520376  WHERE id1 >= 124890 and id1 < 134890
xt-1M-1000-120-1	1623	.25	.5	UPDATE ft_HT1 SET id2 = 14458  WHERE id1 >= 7084 and id1 < 17084
xt-1M-1000-120-1	1661	.25	.75	UPDATE ft_HT2 SET val2 = "4WqBCwUP44TZ5EKdoKbUgYKXZRWXZh1Vsok6MlLgFHxY7YFgMdOfImzLiu4Ygi2m0m2jNHIqgxFH2xtdnSeG4zG2sh"  WHERE id1 >= 710329 and id1 < 720329
xt-1M-1000-120-1	1683	.25	1	UPDATE ft_HT1 SET id3 = 194726  WHERE id1 >= 192779 and id1 < 202779
xt-1M-1000-120-1	1723	.5	.25	UPDATE ft_HT1 SET id2 = 51135  WHERE id1 >= 12272 and id1 < 22272
xt-1M-1000-120-1	1763	.5	.5	UPDATE ft_HT1 SET id4 = 497780  WHERE id1 >= 243912 and id1 < 253912
xt-1M-1000-120-1	1801	.5	.75	UPDATE ft_HT2 SET val2 = "aOoBh75WczSjiQpYKY6pFpO7KxWew2d44AdbeDoyLmYnjIFH6CkPvBwZ5V4dV50a2LJPIaRxnyXl5mDQSmG6naIG"  WHERE id1 >= 672172 and id1 < 682172
xt-1M-1000-120-1	1842	.5	1	UPDATE ft_HT1 SET id2 = 17451  WHERE id1 >= 17277 and id1 < 27277
xt-1M-1000-120-1	1882	.75	.25	UPDATE ft_HT2 SET val2 = "vH47kaz2oLLLKN3LpqGZEmhRXZhpgc1XcZmLBM4PZM1xBPG6ekrKbA4xpY12PmppkpbyPDCIMbfft1BFc5Bhcm2nI"  WHERE id1 >= 219604 and id1 < 229604
xt-1M-1000-120-1	1902	.75	.5	UPDATE ft_HT1 SET id3 = 188732  WHERE id1 >= 92478 and id1 < 102478
xt-1M-1000-120-1	1923	.75	.75	UPDATE ft_HT2 SET id5 = 552210  WHERE id1 >= 408636 and id1 < 418636
xt-1M-1000-120-1	1943	.75	1	UPDATE ft_HT1 SET id4 = 492343  WHERE id1 >= 487419 and id1 < 497419
xt-1M-1000-120-1	1983	1	.25	UPDATE ft_HT2 SET id5 = 634619  WHERE id1 >= 152309 and id1 < 162309
xt-1M-1000-120-1	2022	1	.5	UPDATE ft_HT2 SET id5 = 658883  WHERE id1 >= 322853 and id1 < 332853
xt-1M-1000-120-1	2043	1	.75	UPDATE ft_HT2 SET val1 = "CkmYBZzTm5HGrFBa5UcsdVjc57vC6ydXCBvZB7xoBp1DIakBop5CXS6bS0FXBHoYCNraRmDS3wsHFQXZMICIWMpO"  WHERE id1 >= 518411 and id1 < 528411
xt-1M-1000-120-1	2083	1	1	UPDATE ft_HT1 SET id3 = 243642  WHERE id1 >= 241206 and id1 < 251206
xt-1M-1000-120-4	2203	.25	.25	UPDATE ft_HT1 SET id4 = 489880  WHERE id1 >= 117571 and id1 < 127571
xt-1M-1000-120-4	2222	.25	.5	UPDATE ft_HT2 SET id5 = 567104  WHERE id1 >= 277881 and id1 < 287881
xt-1M-1000-120-4	2224	.25	.75	UPDATE ft_HT1 SET id3 = 226718  WHERE id1 >= 167771 and id1 < 177771
xt-1M-1000-120-4	2225	.25	1	UPDATE ft_HT2 SET val1 = "RPMjqiMvcIXABRSLvvh7h2iUSWImUBTvjZ1YRD2hXWjnApufJ4BmuW67LPkKOWIpNCycULy7IC1cp3657i11qW15v"  WHERE id1 >= 702164 and id1 < 712164
xt-1M-1000-120-4	2228	.5	.25	UPDATE ft_HT2 SET val1 = "bjS4WGJtDVFVWa62gtuOy6r1PsvSwAqLdFgjywoJHyCvc52CZjPEZSZ2xnxrhPRz4BQ4UaryTjxcfMQwZ4d734Rt4R"  WHERE id1 >= 163013 and id1 < 173013
xt-1M-1000-120-4	2242	.5	.5	UPDATE ft_HT2 SET val1 = "opbzVmYwN12FlhMYf5F1bFVhzJqKB2rNiHF5G2wKKT6qJNXauayoMnUpBBa0eSSvzNM5jlMfUNEZMv2FkFPhehdVt"  WHERE id1 >= 397397 and id1 < 407397
xt-1M-1000-120-4	2261	.5	.75	UPDATE ft_HT2 SET val1 = "fRIKrkRKlvNeMU6nud3Q32rWjxvfaeQaOTPmslcoOzHMsBrmLYgRMWQBNiClT4lzEsgKF5dywuBBYA3YbwUlCegL"  WHERE id1 >= 602604 and id1 < 612604
xt-1M-1000-120-4	2263	.5	1	UPDATE ft_HT2 SET id5 = 519428  WHERE id1 >= 514234 and id1 < 524234
xt-1M-1000-120-4	2283	.75	.25	UPDATE ft_HT2 SET val1 = "qOEUmny3XvBpGVqtblXLfAVBiQ2GBejwXflgyLdesD36pVlvYqEzT7J0dTB7K6XYlgwzvjmfAIbpF7jTFkwwtPL"  WHERE id1 >= 179816 and id1 < 189816
xt-1M-1000-120-4	2301	.75	.5	UPDATE ft_HT2 SET id5 = 655307  WHERE id1 >= 321101 and id1 < 331101
xt-1M-1000-120-4	2304	.75	.75	UPDATE ft_HT2 SET val2 = "a3zwenWAORBPTC1ddy1M6B2ZzEu2qMpTeNDvVHFIRsJN65iuoOZGrQi6LTlTDXCvPPMwFusbZMe6fNGjahscM7s3"  WHERE id1 >= 731690 and id1 < 741690
xt-1M-1000-120-4	2322	.75	1	UPDATE ft_HT1 SET id4 = 414882  WHERE id1 >= 410733 and id1 < 420733
xt-1M-1000-120-4	2323	1	.25	UPDATE ft_HT1 SET id4 = 461477  WHERE id1 >= 110754 and id1 < 120754
xt-1M-1000-120-4	2326	1	.5	UPDATE ft_HT1 SET id2 = 16611  WHERE id1 >= 8139 and id1 < 18139
xt-1M-1000-120-4	2342	1	.75	UPDATE ft_HT1 SET id4 = 459762  WHERE id1 >= 340224 and id1 < 350224
xt-1M-1000-120-4	2344	1	1	UPDATE ft_HT2 SET id5 = 523576  WHERE id1 >= 518340 and id1 < 528340
xt-1M-1000-120-8	3664	0	.25	UPDATE ft_HT1 SET id2 = 78465  WHERE id1 >= 18831 and id1 < 28831
xt-1M-1000-120-8	3684	0	.5	UPDATE ft_HT2 SET val2 = "lyGB0IzozUixAXqhHqWNucaDTYhxSSqfh2cj7nhkMNWpxIemFZBuhHNq5s3jLDeIrRyWBMl5lFhRIgkLyVgY0Zyuk"  WHERE id1 >= 455223 and id1 < 465223
xt-1M-1000-120-8	3704	0	.75	UPDATE ft_HT1 SET id2 = 2088  WHERE id1 >= 1545 and id1 < 11545
xt-1M-1000-120-8	3743	0	1	UPDATE ft_HT1 SET id3 = 266018  WHERE id1 >= 263358 and id1 < 273358
xt-1M-1000-120-8	3764	.25	.25	UPDATE ft_HT2 SET val2 = "QBm3HJTgMq4q3CMOIMUA7XOcdeisR0N2IjUlgfjQQIAa23IuA7cA1WnvY6gKgFU65LI5IyGFmmYOV047K5tAjualP"  WHERE id1 >= 217543 and id1 < 227543
xt-1M-1000-120-8	3804	.25	.5	UPDATE ft_HT2 SET val2 = "PyfhGtQXl5KQlvYSPEuLVJhvrCMDbr2CIpePpP7UVRFa7AuNGe33zdXOutqmZhobK5YCoTm1zHTJVHhCKdFZ2cEIw"  WHERE id1 >= 419245 and id1 < 429245
xt-1M-1000-120-8	3806	.25	.75	UPDATE ft_HT2 SET id5 = 538145  WHERE id1 >= 398227 and id1 < 408227
xt-1M-1000-120-8	3823	.25	1	UPDATE ft_HT1 SET id2 = 14350  WHERE id1 >= 14207 and id1 < 24207
xt-1M-1000-120-8	3843	.5	.25	UPDATE ft_HT1 SET id4 = 481095  WHERE id1 >= 115463 and id1 < 125463
xt-1M-1000-120-8	3863	.5	.5	UPDATE ft_HT1 SET id3 = 212131  WHERE id1 >= 103944 and id1 < 113944
xt-1M-1000-120-8	4164	.5	.75	UPDATE ft_HT2 SET val1 = "3MlnwNHy0IStv3dpArDbUrOjhxbfNluV1Ed1VCCcmoEGMi7Sp7K7aYchxk4HnUkm6BHj3oNpPjgKQ6dmJGXBqrrmi"  WHERE id1 >= 595069 and id1 < 605069
xt-1M-1000-120-8	4184	.5	1	UPDATE ft_HT1 SET id2 = 151946  WHERE id1 >= 150427 and id1 < 160427
xt-1M-1000-120-8	4204	.75	.25	UPDATE ft_HT1 SET id3 = 183409  WHERE id1 >= 44018 and id1 < 54018
xt-1M-1000-120-8	4224	.75	.5	UPDATE ft_HT1 SET id3 = 293863  WHERE id1 >= 143993 and id1 < 153993
xt-1M-1000-120-8	4244	.75	.75	UPDATE ft_HT1 SET id4 = 457115  WHERE id1 >= 338265 and id1 < 348265
xt-1M-1000-120-8	4265	.75	1	UPDATE ft_HT1 SET id4 = 481921  WHERE id1 >= 477102 and id1 < 487102
xt-1M-1000-120-8	4384	1	.25	UPDATE ft_HT2 SET id5 = 627806  WHERE id1 >= 150674 and id1 < 160674
pk-xt-30K-1000-120-1	4425	.25	.25	UPDATE ft_HT1 SET id4 = 13710  WHERE id1 >= 3290 and id1 < 3590
pk-xt-30K-1000-120-1	4426	.25	.5	UPDATE ft_HT2 SET id5 = 18406  WHERE id1 >= 9019 and id1 < 9319
pk-xt-30K-1000-120-1	4444	.25	.75	UPDATE ft_HT2 SET val2 = "pXdQriaQahQhCQRuHA70AymY2DOnpGks4lHda0CoFc4vATcxykzufraNOAQLfpOpIRsEQi0bNxZRSqHc6GpuhJzmZ"  WHERE id1 >= 19265 and id1 < 19565
pk-xt-30K-1000-120-1	4445	.25	1	UPDATE ft_HT2 SET val1 = "UuHGvnmhwEyVivugnNOvRSX3mAFPzunOsQsOqmBXIpVGmbAewDFFWMZ2HaZIGKM7Quby4g5eqzgoK0NjiCz0r11m"  WHERE id1 >= 20712 and id1 < 21012
pk-xt-30K-1000-120-1	4464	.5	.25	UPDATE ft_HT2 SET val2 = "buxGOD0uqMguqrzQwiEoi5QVByieG3YKWKUlLczxGagqlfzidWvr0KKlJJHa3hYhJHtptoqOvOFTCrojerzAyEZt"  WHERE id1 >= 6403 and id1 < 6703
pk-xt-30K-1000-120-1	4465	.5	.5	UPDATE ft_HT1 SET id2 = 3006  WHERE id1 >= 1473 and id1 < 1773
pk-xt-30K-1000-120-1	4484	.5	.75	UPDATE ft_HT2 SET id5 = 19562  WHERE id1 >= 14476 and id1 < 14776
pk-xt-30K-1000-120-1	4486	.5	1	UPDATE ft_HT1 SET id4 = 14677  WHERE id1 >= 14530 and id1 < 14830
pk-xt-30K-1000-120-1	4504	.75	.25	UPDATE ft_HT1 SET id3 = 8832  WHERE id1 >= 2120 and id1 < 2420
pk-xt-30K-1000-120-1	4505	.75	.5	UPDATE ft_HT2 SET val2 = "PokthfmHEGU5LnJTDN2wfJDiwaPIzMkjAHG7X7rwDRFtQnsHVNdm0uc42dgkyOtTqTdXSUqzzImVmbi0DRgkFETP"  WHERE id1 >= 13517 and id1 < 13817
pk-xt-30K-1000-120-1	4524	.75	.75	UPDATE ft_HT2 SET id5 = 16296  WHERE id1 >= 12059 and id1 < 12359
pk-xt-30K-1000-120-1	4525	.75	1	UPDATE ft_HT1 SET id3 = 9466  WHERE id1 >= 9372 and id1 < 9672
pk-xt-30K-1000-120-1	4544	1	.25	UPDATE ft_HT2 SET val1 = "PNlFls3YCVqAgbfRhhpWQjXe1pDB1rPv53KUVJp22GRVUYWVwgLYfZAIdwnXXhlgoFVqJIdCzEkAT0lUmJQb33UL"  WHERE id1 >= 4988 and id1 < 5288
pk-xt-30K-1000-120-1	4545	1	.5	UPDATE ft_HT1 SET id3 = 6005  WHERE id1 >= 2942 and id1 < 3242
pk-xt-30K-1000-120-1	4564	1	.75	UPDATE ft_HT2 SET val2 = "uzYrKD2eGTpJaH2DkSYWsERpYmHBy7XNyFlpIeZiS0fQUH7GmFvLw21Jjm5JORzvrPQZIGtv6EbdPFdcJIfSCpB"  WHERE id1 >= 22049 and id1 < 22349
pk-xt-30K-1000-120-1	4565	1	1	UPDATE ft_HT1 SET id3 = 9228  WHERE id1 >= 9136 and id1 < 9436
xt-1M-1000-120-8	4604	1	.5	UPDATE ft_HT2 SET val2 = "4fiN37LPHBYzCmSOKRyohymwRIYHqydTcbKHvZdpHTnUfX2V7eygsFqFShSVlnXbshP1H0HA0Xeb0eBPpopeDHviOU"  WHERE id1 >= 482797 and id1 < 492797
xt-1M-1000-120-8	4625	1	.75	UPDATE ft_HT2 SET val2 = "LyW5Zpk1Nkyu7UqmlfqAhyrfyUC6t4z57yG7cqHAmU5hZmRuNQAQoxPAWC4aLC3R1elZzKxfxOOUztT32B21CrEZl"  WHERE id1 >= 707906 and id1 < 717906
xt-1M-1000-120-8	4724	1	1	UPDATE ft_HT1 SET id2 = 164821  WHERE id1 >= 163172 and id1 < 173172
xt-30K-1000-120-2	6066	.25	.25	UPDATE ft_HT2 SET val1 = "Syb1CIToUHKAsdhQjMZRAVSOUExaSVH5C5mQzGbW06C5R6IfrWLpkDBGi15FOyZWJadPnbsYVqYcyfbtuEgDHC420"  WHERE id1 >= 5153 and id1 < 5453
xt-30K-1000-120-2	6086	.25	.5	UPDATE ft_HT2 SET val1 = "kaVusxDtehn7PFtM4nup4JQGC0qIQLCbmXVcqHPBYsPRl0K2ymmlUBkm6ob60MGKaKotT2vWLaw3VFYvpXK0p3WOYH"  WHERE id1 >= 10072 and id1 < 10372
xt-30K-1000-120-2	6106	.25	.75	UPDATE ft_HT2 SET val2 = "nE6iwcdMeCMTkkIPrwSnOVzBXSVHf5uzNpXjHhoOiqj3VEAsmHMEhSDiiJDPtXpdsR0X71n6itM541TGqJfarpI1z"  WHERE id1 >= 21272 and id1 < 21572
xt-30K-1000-120-2	6107	.25	1	UPDATE ft_HT2 SET val2 = "BfaVdho3B2ctayOK4CPl2BD1JUuL7QcQexf0unN743PBQprCWtzjerECNjr6PNpcmGFe04m3jBXv7DWEXCqOPUd5"  WHERE id1 >= 29213 and id1 < 29513
xt-30K-1000-120-2	6126	.5	.25	UPDATE ft_HT2 SET id5 = 19128  WHERE id1 >= 4591 and id1 < 4891
xt-30K-1000-120-2	6146	.5	.5	UPDATE ft_HT1 SET id4 = 11129  WHERE id1 >= 5453 and id1 < 5753
xt-30K-1000-120-2	6166	.5	.75	UPDATE ft_HT2 SET val1 = "4hZMAOLX5OnLbUXWqygqtmzcfxBNlhU4Skb6AfSRAM4fq1Qj25qq6ELkkqHsrRinbyFd4nnNBRCgZNOtBUbwYlhfq"  WHERE id1 >= 15596 and id1 < 15896
xt-30K-1000-120-2	6167	.5	1	UPDATE ft_HT2 SET id5 = 15582  WHERE id1 >= 15426 and id1 < 15726
xt-30K-1000-120-2	6186	.75	.25	UPDATE ft_HT1 SET id3 = 9112  WHERE id1 >= 2187 and id1 < 2487
xt-30K-1000-120-2	6188	.75	.5	UPDATE ft_HT2 SET val2 = "Uth6rGF11KrJbqT5aoDhLmzcIVGKxJf54Ns3QLHWBzxzssPnqPXc4bcaXYVHGLRZnVxJC5rKUAe44D7lY2qkrCkos"  WHERE id1 >= 13637 and id1 < 13937
xt-30K-1000-120-2	6206	.75	.75	UPDATE ft_HT2 SET val2 = "QVZWl3ZmM7ih5QsQm2KkuA1NzwufqsoRhEl0vkOGfHoQHKTGQzzwQVBiWkBhYMKG5lOOklXt43NqJSCCzgAjzJdQku"  WHERE id1 >= 21073 and id1 < 21373
xt-30K-1000-120-2	6226	.75	1	UPDATE ft_HT1 SET id4 = 13758  WHERE id1 >= 13621 and id1 < 13921
xt-30K-1000-120-2	6246	1	.25	UPDATE ft_HT2 SET id5 = 18089  WHERE id1 >= 4341 and id1 < 4641
xt-30K-1000-120-2	6247	1	.5	UPDATE ft_HT1 SET id3 = 6675  WHERE id1 >= 3270 and id1 < 3570
xt-30K-1000-120-2	6266	1	.75	UPDATE ft_HT1 SET id2 = 827  WHERE id1 >= 612 and id1 < 912
xt-30K-1000-120-2	6267	1	1	UPDATE ft_HT1 SET id2 = 2608  WHERE id1 >= 2582 and id1 < 2882
pk-xt-30K-1000-120-2	7026	.25	.25	UPDATE ft_HT2 SET val1 = "dj5r6Rvpvn66bkWFLAsgLvrAAjHmahOijY6CeFdftKQrbkBPXLlDFDJxRxdMxOQ5u7LOCpQMW1zsqiVkQZGxvEUev"  WHERE id1 >= 4961 and id1 < 5261
pk-xt-30K-1000-120-2	7046	.25	.5	UPDATE ft_HT2 SET val2 = "nClr1ibrczwI6xZoqfKjeWMioLIhtSCukgIGnkVi31GMmpUztcLIoM0KlpMmHGRvouKm3WfnEKeLpMhDsOzyTsctd"  WHERE id1 >= 14024 and id1 < 14324
pk-xt-30K-1000-120-2	7066	.25	.75	UPDATE ft_HT1 SET id4 = 11618  WHERE id1 >= 8598 and id1 < 8898
pk-xt-30K-1000-120-2	7086	.25	1	UPDATE ft_HT2 SET val2 = "uYJKPi2EeVH1drEhMSCvwtltawndLD33Izsh4GQvxonYqH0zEBxIjLMY0rDfwPtHZF7BdeWTV6FYpp7UUHcbtAc7x"  WHERE id1 >= 27470 and id1 < 27770
pk-xt-30K-1000-120-2	7106	.5	.25	UPDATE ft_HT1 SET id3 = 9596  WHERE id1 >= 2303 and id1 < 2603
pk-xt-30K-1000-120-2	7126	.5	.5	UPDATE ft_HT1 SET id3 = 6814  WHERE id1 >= 3339 and id1 < 3639
pk-xt-30K-1000-120-2	7146	.5	.75	UPDATE ft_HT1 SET id3 = 5243  WHERE id1 >= 3880 and id1 < 4180
pk-xt-30K-1000-120-2	7166	.5	1	UPDATE ft_HT2 SET val1 = "nfC0dXdaouUMw5d53ULpm2XLQrFbNiD5dIjtRzrgh0Xwn5tW1DWTeXdWXaECjUm0OwY7p2d7HzV1wZuTQKjEFVRG"  WHERE id1 >= 22769 and id1 < 23069
pk-xt-30K-1000-120-2	7186	.75	.25	UPDATE ft_HT2 SET val1 = "DnvafzQQhhOLvMfFYzOH0qbUtgUgqGHOnyiTQcCCr2aWMPXntCMZHbd4IhZgw5oXNpLfShDKYPptCr5Vyjvdywo"  WHERE id1 >= 5149 and id1 < 5449
pk-xt-30K-1000-120-2	7206	.75	.5	UPDATE ft_HT2 SET id5 = 19557  WHERE id1 >= 9583 and id1 < 9883
pk-xt-1M-1000-120-1	7207	.25	.25	UPDATE ft_HT1 SET id2 = 163571  WHERE id1 >= 39257 and id1 < 49257
pk-xt-30K-1000-120-2	7226	.75	.75	UPDATE ft_HT1 SET id2 = 3224  WHERE id1 >= 2386 and id1 < 2686
pk-xt-1M-1000-120-1	7246	.25	.5	UPDATE ft_HT2 SET val2 = "LcQ1FfCDRsJNLVI4Xt23NqBUGacKFBIFKr4vGaXrruCXu1yLcKlujQ4aC0RSq3avjmCmPlNhXWjUmy5ZbKGEYAoNqN"  WHERE id1 >= 472591 and id1 < 482591
pk-xt-30K-1000-120-2	7266	.75	1	UPDATE ft_HT2 SET id5 = 17550  WHERE id1 >= 17374 and id1 < 17674
pk-xt-1M-1000-120-1	7286	.25	.75	UPDATE ft_HT2 SET val2 = "ghOHXoEty3mUYoFbCMqCr10CZEvWqddag2MQrNolZnA7LiwFECsJHpbyXyWRGr5Pqdvzut62PYyS2JkjEBRqIko3L"  WHERE id1 >= 691877 and id1 < 701877
pk-xt-30K-1000-120-2	7287	1	.25	UPDATE ft_HT1 SET id3 = 8552  WHERE id1 >= 2052 and id1 < 2352
pk-xt-1M-1000-120-1	7306	.25	1	UPDATE ft_HT1 SET id2 = 166501  WHERE id1 >= 164836 and id1 < 174836
pk-xt-30K-1000-120-2	7307	1	.5	UPDATE ft_HT2 SET val1 = "ttMOb6l3c7jmHGzAiPCACmQXvDVoFEH6TCPWzLT5k1XZhNLl4aCqbqHHrztCBgKqBAEFxIoCsRTF6qS0bzJwbYKgP"  WHERE id1 >= 11199 and id1 < 11499
pk-xt-30K-1000-120-2	7326	1	.75	UPDATE ft_HT2 SET id5 = 18194  WHERE id1 >= 13464 and id1 < 13764
pk-xt-1M-1000-120-1	7327	.5	.25	UPDATE ft_HT1 SET id2 = 88719  WHERE id1 >= 21292 and id1 < 31292
pk-xt-30K-1000-120-2	7346	1	1	UPDATE ft_HT1 SET id3 = 5037  WHERE id1 >= 4986 and id1 < 5286
pk-xt-1M-1000-120-1	7366	.5	.5	UPDATE ft_HT1 SET id2 = 8750  WHERE id1 >= 4287 and id1 < 14287
pk-xt-1M-1000-120-1	7406	.5	.75	UPDATE ft_HT2 SET val2 = "glETq6E65YIvFPYDOoMWz24pkrfM7ES2GkxI4Gy5fPGPkRiOgcOZpGwGrqZZRJf6BdgymRdT4TslUk6eO4vlxZMjaJ"  WHERE id1 >= 634449 and id1 < 644449
pk-xt-1M-1000-120-1	7427	.5	1	UPDATE ft_HT1 SET id3 = 327170  WHERE id1 >= 323899 and id1 < 333899
pk-xt-1M-1000-120-1	7467	.75	.25	UPDATE ft_HT1 SET id3 = 186679  WHERE id1 >= 44803 and id1 < 54803
pk-xt-1M-1000-120-1	7506	.75	.5	UPDATE ft_HT1 SET id3 = 246323  WHERE id1 >= 120698 and id1 < 130698
pk-xt-1M-1000-120-1	7546	.75	.75	UPDATE ft_HT1 SET id3 = 238795  WHERE id1 >= 176709 and id1 < 186709
pk-xt-1M-1000-120-1	7587	.75	1	UPDATE ft_HT2 SET val1 = "hV3j2UBQOWQYKISBVPlMMw0gAlF1XsjCEiHeNH0MToZZVDxhIdFBSHzuN4qRA61U2Fz2DFtrYjGCMaHoDMnnsiXv"  WHERE id1 >= 748312 and id1 < 758312
pk-xt-1M-1000-120-1	7627	1	.25	UPDATE ft_HT1 SET id4 = 357497  WHERE id1 >= 85799 and id1 < 95799
pk-xt-1M-1000-120-1	7666	1	.5	UPDATE ft_HT1 SET id2 = 36401  WHERE id1 >= 17836 and id1 < 27836
pk-xt-1M-1000-120-1	7686	1	.75	UPDATE ft_HT1 SET id4 = 382491  WHERE id1 >= 283043 and id1 < 293043
pk-xt-1M-1000-120-1	7706	1	1	UPDATE ft_HT1 SET id2 = 46303  WHERE id1 >= 45840 and id1 < 55840
xt-30K-1000-120-4	7746	.25	.25	UPDATE ft_HT2 SET val2 = "XF26DS622ZoAlgDGUTPH1ozDBYjMsDULRgy4O5YhEEHHpAGuGjYsYA1Su6ULNDBHRzlUPG1owa13zm0DSEUNc0kKZ"  WHERE id1 >= 6655 and id1 < 6955
pk-xt-30K-1000-120-4	8347	.25	.25	UPDATE ft_HT2 SET val2 = "TSmK1MpWRjrSSlTO2mUoxAWZvhIuW6Z552RncvCRBlUO1FF2LobG2XOq1dmbnWHlUunnM0Sad1eHYZT3CLTLtBRO"  WHERE id1 >= 6757 and id1 < 7057
pk-xt-30K-1000-120-4	8446	.25	.5	UPDATE ft_HT2 SET val1 = "K362KiLXWwclFyC6LFvb2Sq72XGP0Cznqvk5nxEPf6vUwm6WpHqdlkJN6yK0ApcgVwQgoHsatzbElS4MFYhJkVeOfe"  WHERE id1 >= 11703 and id1 < 12003
pk-xt-30K-1000-120-4	8467	.25	.75	UPDATE ft_HT1 SET id4 = 11813  WHERE id1 >= 8742 and id1 < 9042
pk-xt-30K-1000-120-4	8506	.25	1	UPDATE ft_HT2 SET val1 = "Od1bdZ76w7wrIZl2sdyO010Z5prZpIYWBgjlModGHb73hqWlY3arMiXthfaxKpAoh3rWYPMZq5PxE4q10ZfoDxNb"  WHERE id1 >= 21160 and id1 < 21460
pk-xt-30K-1000-120-4	8546	.5	.25	UPDATE ft_HT2 SET val2 = "v741LFqIG60mzVHAKofACMpya506oVd7dqrs7NrWnckF66JRurdv7SqaSHWhEx0dfMYHofUNQciM2wCAfjmJFKVpEh"  WHERE id1 >= 6405 and id1 < 6705
pk-xt-30K-1000-120-4	8566	.5	.5	UPDATE ft_HT1 SET id4 = 14087  WHERE id1 >= 6903 and id1 < 7203
pk-xt-30K-1000-120-4	8587	.5	.75	UPDATE ft_HT2 SET val1 = "paSZRKdr0srwd5htJ7GivW322RPiw5CmCyVALIv56uFdjoaiqh5YcxzaJo5COhUQVqPLwhFETdU12GdNHMZe2bEG"  WHERE id1 >= 18384 and id1 < 18684
pk-xt-30K-1000-120-4	8626	.5	1	UPDATE ft_HT2 SET val2 = "pev4ObW0y6cVNtUiBFyGJBnKpKoP6F1PaNxr3fGB6hRRHZuRjBFYdFVryrWYQxV1lWSbYGzTqOb5nQxX3GbMk4AI"  WHERE id1 >= 26523 and id1 < 26823
pk-xt-30K-1000-120-4	8666	.75	.25	UPDATE ft_HT1 SET id4 = 12255  WHERE id1 >= 2941 and id1 < 3241
pk-xt-1M-1000-120-4	8686	.25	.25	UPDATE ft_HT2 SET val1 = "mDsUowWw2Ws06Xi1CVJTMjWrUAQlK6a7SEDdMv0dF7oqEVoNuojxVQq5c45Cq2B6cC7FcJVtyEqgsfIMbXf15teb"  WHERE id1 >= 176429 and id1 < 186429
pk-xt-1M-1000-120-4	8766	.25	.5	UPDATE ft_HT2 SET val2 = "4IBJHjGP6RHLhpFPn6PL53gbIOOA5gucc14Y6sJ2bwiUD0qZa4kykO3Zq2ZYiGqqrsX6KwTTfOj7DdoUZGm6CIORn"  WHERE id1 >= 432982 and id1 < 442982
pk-xt-1M-1000-120-4	8806	.25	.75	UPDATE ft_HT2 SET val1 = "WpzTTsusSe1BuGQnNJSRjRQQwQJKoMaIDJ6yRbBdV0uVMwTXRSNSN0fPlQbFqRYybesLVNLK3mBQkAPSWfh2RsefWj"  WHERE id1 >= 602887 and id1 < 612887
pk-xt-30K-1000-120-4	8826	.75	.5	UPDATE ft_HT1 SET id3 = 7807  WHERE id1 >= 3825 and id1 < 4125
pk-xt-30K-1000-120-4	8846	.75	.75	UPDATE ft_HT2 SET val1 = "1ivy3HjMBGDZtPPCDJdxA5hxCPLf1GCAoKeRWTZ2rzqJbHgFxBnf7ksumvhwjnbiH4tigHebEHllrvYeDCd6Cz"  WHERE id1 >= 18004 and id1 < 18304
pk-xt-30K-1000-120-4	8866	.75	1	UPDATE ft_HT2 SET val2 = "TTURlF1FtEWqA6YNln21RGhSaiBvInBK2h5QrCRpctGSIKCx1es2mUNsiFtWQlCau5XZg1scjXMQq7jLX2AGkonEK"  WHERE id1 >= 25829 and id1 < 26129
pk-xt-30K-1000-120-4	8886	1	.25	UPDATE ft_HT1 SET id4 = 12775  WHERE id1 >= 3066 and id1 < 3366
pk-xt-30K-1000-120-4	8906	1	.5	UPDATE ft_HT1 SET id2 = 714  WHERE id1 >= 349 and id1 < 649
pk-xt-30K-1000-120-4	8926	1	.75	UPDATE ft_HT2 SET id5 = 17203  WHERE id1 >= 12730 and id1 < 13030
pk-xt-30K-1000-120-4	8946	1	1	UPDATE ft_HT1 SET id3 = 9987  WHERE id1 >= 9887 and id1 < 10187
pk-xt-1M-1000-120-2	9266	.25	.25	UPDATE ft_HT2 SET id5 = 619952  WHERE id1 >= 148789 and id1 < 158789
xt-30K-1000-120-8	9286	.25	.25	UPDATE ft_HT2 SET val2 = "DqWsmIaZE3UMrkLN1fYLYQCbMoxQazmoucZ3V6JzcKHGQDLq3ZUCyEhHICCzdWfElrbDEpOXqcT47DFAy4MyADb"  WHERE id1 >= 7159 and id1 < 7459
xt-30K-1000-120-8	9287	.25	.5	UPDATE ft_HT2 SET val1 = "qRKENWcywoqbrY7wtIgSuKFqlpLGh3WA11qGLohcxgoWVhhHsKKiljFDjrsiAFXtpUBkMqAHyVb7Uab7ZzsPqD74H"  WHERE id1 >= 11991 and id1 < 12291
xt-30K-1000-120-8	9288	.25	.75	UPDATE ft_HT2 SET val1 = "Q64VCwtl67iMtu63Nhb6NBZHZYB2EfnSabpWKkhbGnxfkn5lyEejDHl14zKo3bDgyqID0JJKojWGZQcPX2kpGhxniF"  WHERE id1 >= 16678 and id1 < 16978
xt-30K-1000-120-8	9289	.25	1	UPDATE ft_HT2 SET val1 = "bTVumWU5IBjZFIFqG1PHlRu2lvCs6Ln61ADaA4ZD1NtFfcRGic0CzDZhFKaBq1DWGLAgpobcQR5PRNS5a0wvFZmMgP"  WHERE id1 >= 20123 and id1 < 20423
xt-30K-1000-120-8	9290	.5	.25	UPDATE ft_HT1 SET id4 = 13398  WHERE id1 >= 3216 and id1 < 3516
xt-30K-1000-120-8	9291	.5	.5	UPDATE ft_HT2 SET id5 = 16113  WHERE id1 >= 7895 and id1 < 8195
xt-30K-1000-120-8	9292	.5	.75	UPDATE ft_HT2 SET val1 = "BZIz6OsnbOmdpTlYKjqz4dUen6ws6mt6DoklKmLon0WLsgTpbKUy7bbCQcJH6hSAOA2wm1QulQsLgzs7uKxLH75"  WHERE id1 >= 17519 and id1 < 17819
xt-30K-1000-120-8	9293	.5	1	UPDATE ft_HT2 SET val1 = "LLRKQ0LEXJuSx1AbIao3hdB0WYZ5mJRoFwGxeqWZG3HrFXPuRosNmtapqmJ4mBzUPCoFUvdWOl7FLejOxmSvBFwzrR"  WHERE id1 >= 20110 and id1 < 20410
xt-30K-1000-120-8	9294	.75	.25	UPDATE ft_HT2 SET val2 = "BCgkF1vUzn1S6YcFrEom0CLkyZHvbOU2XrPfcuHRUoiKOUUMZdg7f1UKKKMMJmnpXHtT2VESwoWoStzed1iYhS5Lg"  WHERE id1 >= 6958 and id1 < 7258
pk-xt-1M-1000-120-8	9295	.25	.25	UPDATE ft_HT1 SET id4 = 388705  WHERE id1 >= 93289 and id1 < 103289
xt-30K-1000-120-8	9296	.75	.5	UPDATE ft_HT2 SET val1 = "Of70Bp0rWTa3gI3owAoWVlPAiRkHrOltVajDkAXIUwow7fWAQyHQYnJGJNsaPZYcFRZGjgRDVovygzmHhBU2rknKg"  WHERE id1 >= 10430 and id1 < 10730
xt-30K-1000-120-8	9297	.75	.75	UPDATE ft_HT2 SET id5 = 19534  WHERE id1 >= 14455 and id1 < 14755
xt-30K-1000-120-8	9298	.75	1	UPDATE ft_HT2 SET id5 = 19640  WHERE id1 >= 19444 and id1 < 19744
xt-30K-1000-120-8	9299	1	.25	UPDATE ft_HT2 SET id5 = 16331  WHERE id1 >= 3920 and id1 < 4220
xt-30K-1000-120-8	9300	1	.5	UPDATE ft_HT2 SET val2 = "qgoyedGkXDQds0cJYGFKlBHfgSnHCPcYYl5nE7XzFMf1AoO3ys7agXiwUq7KMlcMmcdzFnPTxzIYhjCxn01xHURcXZ"  WHERE id1 >= 14037 and id1 < 14337
xt-30K-1000-120-8	9301	1	.75	UPDATE ft_HT2 SET val1 = "eNzvPiuJNaVRQUY0eiwsbVqvtmctDe3p6urAplpivReYXNrRJlNXIA6BIXqQbcAQsclcKay3zDrGgbdWHKl3CDbD"  WHERE id1 >= 16041 and id1 < 16341
xt-30K-1000-120-8	9302	1	1	UPDATE ft_HT2 SET val2 = "cj6DditdlDv4geW6O6au36ZYRJp6WcmuIq1kONkoXRXG3i4ECRHdbfzvbDjkXHDKs6HhRBurP6EPwsNIjhAzMVYrsJ"  WHERE id1 >= 26941 and id1 < 27241
pk-xt-1M-1000-120-8	9304	.25	.5	UPDATE ft_HT1 SET id2 = 133703  WHERE id1 >= 65514 and id1 < 75514
pk-xt-1M-1000-120-2	9305	.25	.5	UPDATE ft_HT2 SET val2 = "JJb3WplVNmlUIrk63gr31AmUyO0ZfGrNWNDmpnTHD7ZQQACaeIqQu6sSgjIrfM01wliypy3OiHXjhDd7aky0RGU5X"  WHERE id1 >= 417465 and id1 < 427465
pk-xt-1M-1000-120-2	9306	.25	.75	UPDATE ft_HT2 SET id5 = 565699  WHERE id1 >= 418617 and id1 < 428617
pk-xt-1M-1000-120-8	9307	.25	.75	UPDATE ft_HT2 SET val2 = "6QzKuCBo3AXCapOSvOKt2fkB2L1ZMcIo2L6nlIBsRXlSOHLpyGg1aNYyARuoWAdKQslZc0dKoHnd7HWKVFv0lJEbW"  WHERE id1 >= 739762 and id1 < 749762
pk-xt-1M-1000-120-2	9308	.25	1	UPDATE ft_HT2 SET val2 = "EHhwPKwshWMdETWq60y5U1TnQXweGQRAzOIzUqYtc1dGOuNS4poIsAv0gVW5U7AopnhqFErGOtCI0cwcOk4xCk0mo3"  WHERE id1 >= 973050 and id1 < 983050
pk-xt-1M-1000-120-8	9309	.25	1	UPDATE ft_HT2 SET id5 = 590802  WHERE id1 >= 584894 and id1 < 594894
pk-xt-1M-1000-120-2	9310	.5	.25	UPDATE ft_HT1 SET id2 = 65488  WHERE id1 >= 15717 and id1 < 25717
pk-xt-1M-1000-120-8	9311	.5	.25	UPDATE ft_HT1 SET id2 = 78760  WHERE id1 >= 18902 and id1 < 28902
pk-xt-1M-1000-120-2	9312	.5	.5	UPDATE ft_HT1 SET id3 = 188885  WHERE id1 >= 92553 and id1 < 102553
pk-xt-1M-1000-120-2	9313	.5	.75	UPDATE ft_HT1 SET id4 = 383575  WHERE id1 >= 283845 and id1 < 293845
pk-xt-1M-1000-120-8	9314	.5	.5	UPDATE ft_HT1 SET id4 = 494183  WHERE id1 >= 242150 and id1 < 252150
pk-xt-1M-1000-120-2	9315	.5	1	UPDATE ft_HT1 SET id2 = 161383  WHERE id1 >= 159769 and id1 < 169769
pk-xt-1M-1000-120-8	9316	.5	.75	UPDATE ft_HT2 SET val2 = "uTmz0dcccflspZtRZUBPoGojxhAYQPpSbj7rFLfpb7T2CRaJ3C5Aq1gzS4jpkxIAsqlwxfScDPn670FoyBzbN5"  WHERE id1 >= 664816 and id1 < 674816
pk-xt-1M-1000-120-2	9317	.75	.25	UPDATE ft_HT2 SET val1 = "nHD77dc2ExWUqVVKnktwTNuWZ077W0OSSQKIsTEMCWV64LIIbT7Tr01UNb5cgVVFXiAEXuz1tUrf44ykHF5a5T6AR"  WHERE id1 >= 175388 and id1 < 185388
pk-xt-1M-1000-120-8	9318	.5	1	UPDATE ft_HT1 SET id4 = 434212  WHERE id1 >= 429870 and id1 < 439870
pk-xt-1M-1000-120-2	9319	.75	.5	UPDATE ft_HT2 SET val1 = "fxCeBoV7tldLpOGtMcJpR14SkFU3uQCMCQFLx6R6RmfmXHgVDmmddq2gY3rwns2UpAVTWKPaWd3zGQINnoQLtLEIO"  WHERE id1 >= 392820 and id1 < 402820
pk-xt-1M-1000-120-8	9320	.75	.25	UPDATE ft_HT2 SET id5 = 572781  WHERE id1 >= 137468 and id1 < 147468
pk-xt-1M-1000-120-2	9321	.75	.75	UPDATE ft_HT1 SET id3 = 169163  WHERE id1 >= 125180 and id1 < 135180
pk-xt-1M-1000-120-8	9322	.75	.5	UPDATE ft_HT2 SET id5 = 530977  WHERE id1 >= 260179 and id1 < 270179
pk-xt-1M-1000-120-2	9323	.75	1	UPDATE ft_HT2 SET val2 = "EtZrwaPzuLrnBVLMzDVUJrjdnTvxplmALVA40LA4uByR01kg04M44iJPtqwTdp7lgVWkjvvXH7cwpzso2Ac7fx"  WHERE id1 >= 840404 and id1 < 850404
pk-xt-1M-1000-120-8	9328	.75	.75	UPDATE ft_HT2 SET val1 = "elKKcffQtLkMpvao6thZHDg2hjODEXtSbBNpLv6wxrhZvUlms7L6vsGQ4ReoaUTsfgk0XbEcNhyfThsGKWvSThI"  WHERE id1 >= 525028 and id1 < 535028
pk-xt-1M-1000-120-2	9329	1	.25	UPDATE ft_HT2 SET val1 = "rBEFDcYmlaZ74l1U3qtuYciukJ5amMTRjhQ4E1ocRxGwZHYkIsk0QgviI5tQXSQvRuQSlsdVTptwMjMQbIdvJAt"  WHERE id1 >= 171174 and id1 < 181174
pk-xt-1M-1000-120-2	9334	1	.5	UPDATE ft_HT1 SET id4 = 348097  WHERE id1 >= 170567 and id1 < 180567
pk-xt-1M-1000-120-8	9336	.75	1	UPDATE ft_HT1 SET id2 = 96783  WHERE id1 >= 95815 and id1 < 105815
pk-xt-1M-1000-120-2	9337	1	.75	UPDATE ft_HT1 SET id3 = 214660  WHERE id1 >= 158849 and id1 < 168849
pk-xt-1M-1000-120-8	9339	1	.25	UPDATE ft_HT2 SET val2 = "vnWAPSCgmIJtMFVCpVKeAElQO6rWBj31N5zwiC5PmOTzCrk4td5Ncrl5iPd6HBwZLKII3sXhjihN0IVMx7SvHQfbT"  WHERE id1 >= 215345 and id1 < 225345
pk-xt-1M-1000-120-2	9340	1	1	UPDATE ft_HT1 SET id2 = 157712  WHERE id1 >= 156135 and id1 < 166135