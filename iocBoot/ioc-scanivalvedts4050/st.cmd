#!../../bin/linux-x86_64/scanivalveDts4050

< envPaths

epicsEnvSet("STREAM_PROTOCOL_PATH", ".:$(TOP)/proto")
epicsEnvSet("PREFIX", "MDAS:SVDTS4050:")
epicsEnvSet("PORT", "P0")

epicsEnvSet("AS_PATH", "$(TOP)/iocBoot/$(IOC)/autosave")

dbLoadDatabase("$(TOP)/dbd/scanivalveDts4050.dbd")
scanivalveDts4050_registerRecordDeviceDriver(pdbbase)

drvAsynIPPortConfigure("$(PORT)", "192.168.79.33:23")

# Debug flags
#asynSetTraceMask("$(PORT)", 0, device|driver)
#asynSetTraceIOMask("$(PORT)", 0, ascii|hex)

dbLoadRecords("$(TOP)/db/scanivalveDts4050.db","P=$(PREFIX),R=,PORT=$(PORT)")
dbLoadRecords("$(ASYN)/db/asynRecord.db","P=$(PREFIX),R=asyn,PORT=$(PORT),ADDR=0,OMAX=32,IMAX=32")

set_requestfile_path("$(AS_PATH)")
set_savefile_path("$(AS_PATH)")

iocInit()

# Force any ongoing scan to stop
dbpf $(PREFIX)StopScan 1

# Force a scan of Version and Status
dbpf $(PREFIX)Version.PROC 1
dbpf $(PREFIX)Status.PROC 1
dbpf $(PREFIX)Status.SCAN "1 second"

# Set a default avg and trig div
dbpf $(PREFIX)Average 1
dbpf $(PREFIX)ExtTriggerDiv 10

save_restoreSet_Debug(0)
makeAutosaveFileFromDbInfo("$(AS_PATH)/info_settings.req", "autosaveFields")
create_monitor_set("info_settings.req", 30, "")
