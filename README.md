Digital TV Parser
================================

It's a digital television parser, implemented in Ruby. It allows you to filter a specific pid or view all services incoming in a PAT packet.

Filter PIDs from .ts to .ts
-------------------------

    ruby pid_filter.rb a b c

where:
  
* a = path to .ts source file
* b = path to .ts destination file
* c = pid to filter

e.g. to filter PATs:

    ruby pid_filter.rb ~/tvd/sample533.ts ~/tvd/pats.ts 0x00




View services in the PAT:
-------------------------

    ruby services_from_pat.rb path_to_ts_file


e.g.:

    ruby services_from_pat.rb ~/tvd/sample533.ts

print:

<table>
    <tr>
        <th align="center">SERVICES: 3</th>
    </tr>

    <tr>
        <td>program_number: 0x0000 - network_PID    : 0x0010</td>
    </tr>
    <tr>
        <td>program_number: 0xe760 - program_map_PID: 0x0101</td>
    </tr>
    <tr>
        <td>program_number: 0xe761 - program_map_PID: 0x0102</td>
    <tr>
    </tr>
        <td>program_number: 0xe762 - program_map_PID: 0x0103</td>
    </tr>
</table>
