## ~NetshareDump
**A simple, effective script for automatically dumping network shares.**

#### Disclaimer
This tool is only intended to be a proof of concept demonstration tool for authorized security testing. Make sure you check with your local laws before running this tool.

#### Input file
Input file must contain UNC paths :

    \\corp.local\root
    \\corp.local\sales
    \\corp.local\NETLOGON

#### Usage
Example 1 - *List files that match the extension filter*

    NetShareDump.ps1 -inputFile .\unc_list.txt -extensions ".pdf",".xlsx",".csv" -outPath "C:\dump\" -verbose

Example 2 - *Copy files that match the extension filter*

    NetShareDump.ps1 -inputFile .\unc_list.txt -extensions ".pdf",".xlsx",".csv" -outPath "C:\dump\" -verbose -listOnly
![enter image description here](https://github.com/onSec-fr/NetshareDump/blob/main/image.png?raw=true)