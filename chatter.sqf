if (!isserver) exitwith {};
sleep 10;
[leader i1,localize "STR_PSZ_Mission_chatter_l1"] remoteExec ["sidechat",0];
sleep 8;
[leader players,localize "STR_PSZ_Mission_chatter_l2"] remoteExec ["sidechat",0];
sleep 10;
[leader i1,localize "STR_PSZ_Mission_chatter_l3"] remoteExec ["sidechat",0];
sleep 8;
[leader players,localize "STR_PSZ_Mission_chatter_l4"] remoteExec ["sidechat",0];
[["Tsk2",localize "STR_PSZ_Mission_tsk2_title",localize "STR_PSZ_Mission_tsk2_desc"],SHK_Taskmaster_add] remoteExec ["call",0,true];