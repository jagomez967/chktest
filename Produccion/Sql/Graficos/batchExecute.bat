for %%G in (*.sql) do sqlcmd /S 204.16.5.107 /d CheckPOS_Unificada_Final_2 -U CheckPOS_User -P f18qRZKiQLFD -i"%%G"
pause