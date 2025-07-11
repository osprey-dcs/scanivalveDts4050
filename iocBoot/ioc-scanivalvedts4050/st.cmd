#!../../bin/linux-x86_64/scanivalveDts4050

< envPaths

epicsEnvSet("STREAM_PROTOCOL_PATH", ".:$(TOP)/proto")
epicsEnvSet("PREFIX", "SVDTS4050:")
epicsEnvSet("PORT", "P0")

epicsEnvSet("AS_PATH", "$(TOP)/iocBoot/$(IOC)/autosave")

dbLoadDatabase("$(TOP)/dbd/scanivalveDts4050.dbd")
scanivalveDts4050_registerRecordDeviceDriver(pdbbase)

drvAsynIPPortConfigure("$(PORT)", "localhost:2323")
asynOctetSetInputEos("$(PORT)",0,"\r\n")
asynOctetSetOutputEos("$(PORT)",0,"\r\n")
asynSetTraceMask("$(PORT)", 0, device|driver)
#asynSetTraceMask("$(PORT)", 0, 0xFF)
asynSetTraceIOMask("$(PORT)", 0, ascii)

dbLoadRecords("$(TOP)/db/scanivalveDts4050.db","P=$(PREFIX),R=,PORT=$(PORT)")
dbLoadRecords("$(ASYN)/db/asynRecord.db","P=$(PREFIX),R=asyn,PORT=$(PORT),ADDR=0,OMAX=32,IMAX=32")

set_requestfile_path("$(AS_PATH)")
set_savefile_path("$(AS_PATH)")

iocInit()

save_restoreSet_Debug(0)
makeAutosaveFileFromDbInfo("$(AS_PATH)/info_settings.req", "autosaveFields")
create_monitor_set("info_settings.req", 30, "")
