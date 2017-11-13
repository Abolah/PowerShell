$PrinterIP = "192.168.1.12"
$PrinterPort = "9100"
$PrinterPortName = "IP_" + $PrinterIP
$DriverName = "EPSON XP-605"
$DriverPath = ""
$DriverInf = ""
$PrinterCaption = "WMI TEST PRINTER"
####################################################

Function CreatePrinterPort
{
	param ($PrinterIP,
		$PrinterPort,
		$PrinterPortName,
		$ComputerName)
	$wmi = [wmiclass]"\\$ComputerName\root\cimv2:win32_tcpipPrinterPort"
	$wmi.psbase.scope.options.enablePrivileges = $true
	$Port = $wmi.createInstance()
	$Port.name = $PrinterPortName
	$Port.hostAddress = $PrinterIP
	$Port.portNumber = $PrinterPort
	$Port.SNMPEnabled = $false
	$Port.Protocol = 1
	$Port.put_
}

Function InstallPrinterDriver
{
	Param ($DriverName,
		$DriverPath,
		$DriverInf,
		$ComputerName)
	$wmi = [wmiclass]"\\$ComputerName\Root\cimv2:Win32_PrinterDriver"
	$wmi.psbase.scope.options.enablePrivileges = $true
	$wmi.psbase.Scope.Options.Impersonation = `
	[System.Management.ImpersonationLevel]::Impersonate
	$Driver = $wmi.CreateInstance()
	$Driver.Name = $DriverName
	$Driver.DriverPath = $DriverPath
	$Driver.InfName = $DriverInf
	$wmi.AddPrinterDriver($Driver)
	$wmi.Put_
}

Function CreatePrinter
{
	param ($PrinterCaption,
		$PrinterPortName,
		$DriverName,
		$ComputerName)
	$wmi = ([WMIClass]"\\$ComputerName\Root\cimv2:Win32_Printer")
	$Printer = $wmi.CreateInstance()
	$Printer.Caption = $PrinterCaption
	$Printer.DriverName = $DriverName
	$Printer.PortName = $PrinterPortName
	$Printer.DeviceID = $PrinterCaption
	$Printer.Put_
}

CreatePrinterPort
InstallPrinterDriver
CreatePrinter