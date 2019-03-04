for %%G in (*.sql) do sqlcmd /S 192.168.10.9 /d mattel_84 -U alan -P 36990323 -i"%%G"
pause