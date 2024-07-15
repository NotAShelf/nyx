{lib, ...}: let
  inherit (lib.kernel) no unset;
  inherit (lib.attrsets) mapAttrs;
  inherit (lib.modules) mkForce;
in {
  boot.kernelPatches = [
    {
      name = "disable-unused-features";
      patch = null;
      extraStructuredConfig = mapAttrs (_: mkForce) {
        ATALK = no;
        BATMAN_ADV = no;
        CAIF = no;
        COMEDI = no;
        DVB_CORE = no;
        FB_TFT = no;
        IIO = no;
        INPUT_TOUCHSCREEN = no;
        NFC = no;
        SND_FIREWIRE = unset;
        USB_GSPCA = no;
        USB_SERIAL = no;
        USB_SERIAL_CONSOLE = unset;
        USB_SERIAL_GENERIC = unset;
        WATCHDOG = no;
        WATCHDOG_SYSFS = unset;
        XEN = no;

        CRYPTO_842 = no;
        DEBUG_MISC = no;
        DEBUG_PREEMPT = no;
        HIBERNATION = no;
        KEXEC = no;
        KEXEC_FILE = no;

        "60XX_WDT" = no;
        "6LOWPAN" = no;
        "8139CP" = no;
        "8139TOO" = no;
        "8139TOO_8129" = no;

        ALIENWARE_WMI = no;
        ALIM1535_WDT = no;
        ALIM7101_WDT = no;
        ALTERA_MBOX = no;
        ALTERA_MSGDMA = no;
        ALTERA_TSE = no;
        ALX = no;

        GENERIC_ADC_BATTERY = no;
        IP5XXX_POWER = no;
        TEST_POWER = no;
        CHARGER_ADP5061 = no;
        BATTERY_CW2015 = no;
        BATTERY_DS2760 = no;
        BATTERY_DS2780 = no;
        BATTERY_DS2781 = no;
        BATTERY_DS2782 = no;
        BATTERY_SAMSUNG_SDI = no;
        BATTERY_SBS = no;
        CHARGER_SBS = no;
        MANAGER_SBS = no;
        BATTERY_BQ27XXX = no;
        BATTERY_BQ27XXX_I2C = no;
        BATTERY_BQ27XXX_HDQ = no;
        BATTERY_BQ27XXX_DT_UPDATES_NVM = no;
        CHARGER_DA9150 = no;
        BATTERY_AXP20X = no;
        AXP20X_POWER = no;
        AXP288_CHARGER = no;
        AXP288_FUEL_GAUGE = no;
        BATTERY_MAX17040 = no;
        BATTERY_MAX17042 = no;
        BATTERY_MAX1721X = no;
        CHARGER_PCF50633 = no;
        CHARGER_ISP1704 = no;
        CHARGER_MAX8903 = no;
        CHARGER_LP8727 = no;
        CHARGER_GPIO = no;
        CHARGER_MANAGER = no;
        CHARGER_LT3651 = no;
        CHARGER_LTC4162L = no;
        CHARGER_MAX14577 = no;
        CHARGER_MAX77693 = no;
        CHARGER_MAX77976 = no;
        CHARGER_MP2629 = no;
        CHARGER_MT6360 = no;
        CHARGER_MT6370 = no;
        CHARGER_BQ2415X = no;
        CHARGER_BQ24190 = no;
        CHARGER_BQ24257 = no;
        CHARGER_BQ24735 = no;
        CHARGER_BQ2515X = no;
        CHARGER_BQ25890 = no;
        CHARGER_BQ25980 = no;
        CHARGER_BQ256XX = no;
        CHARGER_SMB347 = no;
        BATTERY_GAUGE_LTC2941 = no;
        BATTERY_GOLDFISH = no;
        BATTERY_RT5033 = no;
        CHARGER_RT5033 = no;
        CHARGER_RT9455 = no;
        CHARGER_RT9467 = no;
        CHARGER_RT9471 = no;
        CHARGER_CROS_USBPD = no;
        CHARGER_CROS_PCHG = no;
        CHARGER_BD99954 = no;
        CHARGER_WILCO = no;
        BATTERY_SURFACE = no;
        CHARGER_SURFACE = no;
        BATTERY_UG3105 = no;
        FUEL_GAUGE_MM8013 = no;

        GENERIC_IRQ_DEBUGFS = no;

        # remove samba support
        CIFS = no;
        CIFS_ROOT = no;

        # disable amdgpu cik support
        DRM_AMDGPU_CIK = no;

        # disable radeon drivers
        DRM_RADEON = no;
        FB_RADEON = no;
        FB_RADEON_I2C = no;
        FB_RADEON_BACKLIGHT = no;

        # disable ngreedia drivers
        NET_VENDOR_NVIDIA = no;
        I2C_NVIDIA_GPU = no;
        FB_NVIDIA = no;
        FB_NVIDIA_I2C = no;
        FB_NVIDIA_BACKLIGHT = no;
        HID_NVIDIA_SHIELD = no;
        TYPEC_NVIDIA_ALTMODE = no;
        NVIDIA_WMI_EC_BACKLIGHT = no;

        # firewire
        FIREWIRE = no;
        FIREWIRE_OHCI = no;
        FIREWIRE_SBP2 = no;
        FIREWIRE_NET = no;
        FIREWIRE_NOSY = no;

        # ms surface hid
        SURFACE_AGGREGATOR = no;

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

        # disable unused soc modules
        SND_SOC_CHV3_I2S = no;
        SND_SOC_ADI = no;
        SND_SOC_APPLE_MCA = no;
        SND_ATMEL_SOC = no;
        SND_DESIGNWARE_I2S = no;
        SND_SOC_FSL_ASRC = no;
        SND_SOC_FSL_SAI = no;
        SND_SOC_FSL_MQS = no;
        SND_SOC_FSL_AUDMIX = no;
        SND_SOC_FSL_SSI = no;
        SND_SOC_FSL_SPDIF = no;
        SND_SOC_FSL_ESAI = no;
        SND_SOC_FSL_MICFIL = no;
        SND_SOC_FSL_EASRC = no;
        SND_SOC_FSL_XCVR = no;
        SND_SOC_FSL_UTILS = no;
        SND_SOC_FSL_RPMSG = no;
        SND_I2S_HI6210_I2S = no;
        SND_SOC_IMG = no;
        SND_SOC_STI = no;
        SND_SOC_XILINX_I2S = no;
        SND_SOC_XILINX_AUDIO_FORMATTER = no;
        SND_SOC_XILINX_SPDIF = no;
        SND_XEN_FRONTEND = no;

        INFINIBAND = no;
        INFINIBAND_IPOIB = unset;
        INFINIBAND_IPOIB_CM = unset;
        NET_DSA = no;
        NET_VENDOR_CISCO = no;
        NET_VENDOR_HUAWEI = no;
        NET_VENDOR_MARVELL = no;
        NET_VENDOR_MELLANOX = no;
        NET_VENDOR_RENESAS = no;
        NET_VENDOR_STMICRO = no;
        RT2800USB_RT53XX = unset;
        RT2800USB_RT55XX = unset;
        WLAN_VENDOR_MARVELL = no;
        WLAN_VENDOR_MEDIATEK = no;
        WLAN_VENDOR_RALINK = no;
        X25 = no;

        AFFS_FS = no;
        AFS_FS = no;
        BEFS_FS = no;
        CODA_FS = no;
        JFS_FS = no;
        OCFS2_FS = no;
        OMFS_FS = no;
        ORANGEFS_FS = no;
        SYSV_FS = no;

        CHROME_PLATFORMS = no;
        CHROMEOS_LAPTOP = unset;
        CHROMEOS_PSTORE = unset;
        CHROMEOS_TBMC = unset;
        CROS_EC = unset;
        CROS_EC_I2C = unset;
        CROS_EC_ISHTP = unset;
        CROS_EC_LPC = unset;
        CROS_EC_SPI = unset;
        CROS_KBD_LED_BACKLIGHT = unset;

        SND_SOC = no;
        SND_SOC_INTEL_SOUNDWIRE_SOF_MACH = unset;
        SND_SOC_INTEL_USER_FRIENDLY_LONG_NAMES = unset;
        SND_SOC_SOF_ACPI = unset;
        SND_SOC_SOF_APOLLOLAKE = unset;
        SND_SOC_SOF_CANNONLAKE = unset;
        SND_SOC_SOF_COFFEELAKE = unset;
        SND_SOC_SOF_COMETLAKE = unset;
        SND_SOC_SOF_ELKHARTLAKE = unset;
        SND_SOC_SOF_GEMINILAKE = unset;
        SND_SOC_SOF_HDA_AUDIO_CODEC = unset;
        SND_SOC_SOF_HDA_LINK = unset;
        SND_SOC_SOF_ICELAKE = unset;
        SND_SOC_SOF_INTEL_TOPLEVEL = unset;
        SND_SOC_SOF_JASPERLAKE = unset;
        SND_SOC_SOF_MERRIFIELD = unset;
        SND_SOC_SOF_PCI = unset;
        SND_SOC_SOF_TIGERLAKE = unset;
        SND_SOC_SOF_TOPLEVEL = unset;

        HUAWEI_WMI = no;
      };
    }
  ];
}
