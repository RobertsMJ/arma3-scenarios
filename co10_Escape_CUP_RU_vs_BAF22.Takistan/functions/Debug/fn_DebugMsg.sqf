params [["_msg","Empty message"]];
waituntil{time>2};
if(A3E_Debug) then {
    [[_msg],"a3e_fnc_systemChat",true] call BIS_fnc_MP;
	 [[_msg],"a3e_fnc_rptLog",true] call BIS_fnc_MP;
};