{ ... }:
{
  powerManagement = {
    enable = true;
    # power consumption analysis for Intel laptops
    powertop.enable = true;
  };

  services.upower.enable = true;

  ### Power management utilities
  # services.thermald.enable = true;
  # services.auto-cpufreq.enable = true;

  systemd.sleep.settings.Sleep = {
    AllowSuspend = true;
    AllowHibernation = true;
    AllowHybridSleep = true;
    AllowSuspendThenHibernate = true;
    SuspendState = "freeze";
    # s2ram
    # may be buggy for some machines and just reboot instead of suspend
    # doesn't work for me huh
    #SuspendState = "mem";
    #MemorySleepMode = "deep";
    HibernateMode = "platform";
    HibernateOnACPower = false;
    # hibernates only when battery looses 5% (estimated after some time of suspend)
    SuspendEstimationSec = "10min";
    #HibernateDelaySec = "1hr";
  };

  services.logind.settings.Login = {
    IdleAction = "sleep";
    IdleActionSec = "5min";
    InhibitDelayMaxSec = "15s";
    SleepOperation = "suspend";
    HandlePowerKey = "ignore";
    HandlePowerKeyLongPress = "hibernate";
    HandleSuspendKey = "suspend";
    HandleSuspendKeyLongPress = "reboot";
    HandleLidSwitch = "sleep";
    HandleLidSwitchExternalPower = "sleep";
    HandleLidSwitchDocked = "ignore";
  };
}
