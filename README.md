# SCCMScripts
SCCM Scripts
These are a series of scripts I've devloped for use with SCCM Orchestration groups to carry out tasks such as
  Enter and Exit maintenance mode in SCOM
  create and delete DNS entries in AD DNS

This was to aid in automation of patching via SCCM, and would automate removal of DNS records for DNS Round Robin "Clusters" while a server is being patched, and re-instate it once patching is complete. 
Also by using maintenance mode rather than just pausing the SCOM agent, better information was collected via SCOM and normal alerts during reboot were suppressed removing noise in the SCOM alerts
