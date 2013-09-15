Digital TV Parser
==========

* To filter PIDs from .ts to .ts
	ruby pid_filter.rb a b c

	where
		a = path_ts_src_file
		b = path_ts_dest_file
		c = pid_to_filter

	e.g. to filter PATs:
		ruby pid_filter.rb ~/tvd/sample533.ts ~/tvd/pats.ts 0x00



* To view services in the PAT:
	ruby services_from_pat.rb path_to_ts_file


e.g.: ruby services_from_pat.rb ~/tvd/sample533.ts

______________________________________________________
|                   SERVICES: 3                      |
|____________________________________________________|
|  program_number: 0x0000 | network_PID    : 0x0010  |
|  program_number: 0xe760 | program_map_PID: 0x0101  |
|  program_number: 0xe761 | program_map_PID: 0x0102  |
|  program_number: 0xe762 | program_map_PID: 0x0103  |
|____________________________________________________|

