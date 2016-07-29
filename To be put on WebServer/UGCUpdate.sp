#pragma semicolon 1
#include <sourcemod>
#include <socket>
#include <updater>

#define PLUGIN_VERSION "1.0"

#define CVAR_MAXLEN 64
#define MAX_URL_LENGTH 256
#define UPDATE_URL "http://miggthulu.com/integritf2/updatefile.txt"

//#include helpers/download_socket.sp
#include helpers/filesys.sp

public Plugin myinfo = {
	name        = "UGCUpdater",
	author      = "Miggy, Quantic",
	description = "Plugin that updates files on UGC servers",
	version		= PLUGIN_VERSION,
	url         = "ugcleague.com"
};

// Global Variables
ConVar g_UpdaterSetting;
ConVar g_IPLogging;


void initConVar(ConVar convar)
{
	if (convar == INVALID_HANDLE)
		return;
	convar.AddChangeHook(OnConVarChanged);
	resetConVar(convar);
}

void resetConVar(ConVar convar)
{
		convar.RestoreDefault(true, true);
}


public void OnPluginStart()
{
	/** Starts IP Logging **/
	SetConVarInt(FindConVar("sm_paranoia_ip_verbose"), 1, true);
	/** Sets Updater **/
	SetConVarInt(FindConVar("sm_updater"), 2, true);

	/** Locks down above mentioned CVARS from being disabled by RCON users **/
	g_UpdaterSetting= FindConVar("sm_updater");
	initConVar(g_UpdaterSetting);
	
	g_IPLogging= FindConVar("sm_paranoia_ip_verbose");
	initConVar(g_IPLogging);
}

	

public OnLibraryAdded(const String:name[])
{
	if (StrEqual(name, "updater"))
	{
		Updater_AddPlugin(UPDATE_URL);
	}
}



public void OnConVarChanged(ConVar convar, char[] oldValue, char[] newValue)
{
	char convarDefault[CVAR_MAXLEN];
	char convarName[CVAR_MAXLEN];
	convar.GetDefault(convarDefault, sizeof(convarDefault));
	convar.GetName(convarName, sizeof(convarName));


	if (StringToInt(convarDefault) != StringToInt(newValue))
	{
		//PrintToChatAll("[UGCUpdater] Attempt to change cvar %s to %s (looking for %s), reverting changes...", convarName, newValue, convarDefault);
		resetConVar(convar);
	}
}


public void OnPluginEnd()
{
	//PrintToChatAll("[UGCUpdater] has been unloaded.");
}



void DownloadEnded(bool successful, char error[]="")
{
	if ( ! successful) {
		LogError("Download attempt failed: %s", error);
		return;
	}
}

