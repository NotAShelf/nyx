{lib, ...}: let
  inherit (lib.kernel) no;
  inherit (lib.attrsets) mapAttrs;
  inherit (lib.modules) mkForce;
in {
  boot.kernelPatches = [
    {
      name = "Disable Unused Features";
      patch = null;
      extraStructuredConfig = mapAttrs (_: mkForce) {
        CRYPTO_842 = no;
        DEBUG_MISC = no;
        DEBUG_PREEMPT = no;
        GCC_PLUGINS = no;
        HIBERNATION = no;
        KEXEC = no;
        KEXEC_FILE = no;

        "60XX_WDT" = no;
        "6LOWPAN" = no;
        "8139CP" = no;
        "8139TOO" = no;
        "8139TOO_8129" = no;

        ACENIC = no;
        ACERHDF = no;
        ACER_WIRELESS = no;
        ACER_WMI = no;
        ACPI_AC = no;
        ACPI_BATTERY = no;
        ACPI_CMPC = no;
        ACPI_CPPC_LIB = no;
        ACPI_DOCK = no;
        ACPI_EC_DEBUGFS = no;
        ACPI_FAN = no;
        ACPI_IPMI = no;
        ACPI_NFIT = no;
        ACPI_NUMA = no;
        ACPI_SBS = no;
        ACPI_TABLE_UPGRADE = no;
        ACPI_TINY_POWER_BUTTON = no;
        ACQUIRE_WDT = no;
        AD525X_DPOT = no;
        ADAPTEC_STARFIRE = no;
        ADFS_FS = no;
        ADIN_PHY = no;
        ADVANTECH_WDT = no;
        ADV_SWBUTTON = no;
        AFFS_FS = no;
        AF_KCM = no;
        AF_RXRPC = no;
        ALIENWARE_WMI = no;
        ALIM1535_WDT = no;
        ALIM7101_WDT = no;
        ALTERA_MBOX = no;
        ALTERA_MSGDMA = no;
        ALTERA_TSE = no;
        ALX = no;

        DELL_RBTN = no;
        DELL_RBU = no;
        DELL_SMBIOS = no;
        DELL_WMI = no;
        DELL_WMI_AIO = no;
        DELL_WMI_DESCRIPTOR = no;
        DELL_WMI_LED = no;
        DELL_WMI_SYSMAN = no;

        HID_A4TECH = no;
        HID_ACRUX = no;
        HID_ALPS = no;
        HID_APPLEIR = no;
        HID_ASUS = no;
        HID_AUREAL = no;
        HID_BETOP_FF = no;
        HID_BIGBEN_FF = no;
        HID_CMEDIA = no;
        HID_COUGAR = no;
        HID_CREATIVE_SB0540 = no;
        HID_CYPRESS = no;
        HID_DRAGONRISE = no;
        HID_ELAN = no;
        HID_ELECOM = no;
        HID_ELO = no;
        HID_EMS_FF = no;
        HID_EZKEY = no;
        HID_GEMBIRD = no;
        HID_GFRM = no;
        HID_GOOGLE_HAMMER = no;
        HID_GREENASIA = no;
        HID_GT683R = no;
        HID_GYRATION = no;
        HID_HOLTEK = no;
        HID_HYPERV_MOUSE = no;
        HID_ICADE = no;
        HID_ITE = no;
        HID_KEYTOUCH = no;
        HID_KYE = no;
        HID_LCPOWER = no;
        HID_LED = no;
        HID_MALTRON = no;
        HID_MCP2221 = no;
        HID_MONTEREY = no;
        HID_MULTITOUCH = no;
        HID_NTI = no;
        HID_NTRIG = no;
        HID_PANTHERLORD = no;
        HID_PENMOUNT = no;
        HID_PETALYNX = no;
        HID_PICOLCD = no;
        HID_PLAYSTATION = no;
        HID_PRIMAX = no;
        HID_REDRAGON = no;
        HID_RETRODE = no;
        HID_RMI = no;
        HID_RMI4 = no;
        HID_ROCCAT = no;
        HID_SAITEK = no;
        HID_SAMSUNG = no;
        HID_SEMITEK = no;
        HID_SMARTJOYPLUS = no;
        HID_SONY = no;
        HID_SPEEDLINK = no;
        HID_SUNPLUS = no;
        HID_THINGM = no;
        HID_THRUSTMASTER = no;
        HID_TIVO = no;
        HID_TOPSEED = no;
        HID_TWINHAN = no;
        HID_U2FZERO = no;
        HID_UCLOGIC = no;
        HID_UDRAW_PS3 = no;
        HID_VIEWSONIC = no;
        HID_VIVALDI = no;
        HID_WALTOP = no;
        HID_WIIMOTE = no;
        HID_XINMO = no;
        HID_ZEROPLUS = no;
        HID_ZYDACRON = no;
      };
    }
  ];
}
