#pragma semicolon 1

#include <sourcemod>
#include <sdktools>

#pragma newdecls required

ConVar g_ConVar_HostTimeScale;

public Plugin myinfo =
{
	name = "Fix host_timescale",
	author = ".Rushaway",
	description = "Block host_timescale bug from crashing your server.",
	version = "1.0",
	url = ""
};

public void OnPluginStart()
{
	g_ConVar_HostTimeScale = FindConVar("host_timescale");
	g_ConVar_HostTimeScale.AddChangeHook(OnConVarChanged);
}

public void OnMapEnd()
{
	g_ConVar_HostTimeScale.IntValue = 1;
}

public void OnConVarChanged(ConVar convar, const char[] oldValue, const char[] newValue)
{
	if (convar.IntValue < 1)
	{
		convar.IntValue = 1;
		for (int i = 0; i < 4; i++)
			PrintToChatAll("Setting host_timescale to values less than 1 will crash the server!!!");
	}
}
