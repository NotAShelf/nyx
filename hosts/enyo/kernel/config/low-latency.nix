{lib, ...}: let
  inherit (lib.kernel) yes no freeform;
  inherit (lib.attrsets) mapAttrs;
  inherit (lib.modules) mkForce;
in {
  boot.kernelPatches = [
    {
      name = "Lower latency";
      patch = null;
      extraStructuredConfig = mapAttrs (_: mkForce) {
        HZ = freeform "1000";
        HZ_1000 = yes;

        PREEMPT = yes;
        PREEMPT_BUILD = yes;
        PREEMPT_COUNT = yes;
        PREEMPT_VOLUNTARY = no;
        PREEMPTION = yes;

        TREE_RCU = yes;
        PREEMPT_RCU = yes;
        RCU_EXPERT = yes;
        TREE_SRCU = yes;
        TASKS_RCU_GENERIC = yes;
        TASKS_RCU = yes;
        TASKS_RUDE_RCU = yes;
        TASKS_TRACE_RCU = yes;
        RCU_STALL_COMMON = yes;
        RCU_NEED_SEGCBLIST = yes;
        RCU_FANOUT = freeform "64";
        RCU_FANOUT_LEAF = freeform "16";
        RCU_BOOST = yes;
        RCU_BOOST_DELAY = freeform "500";
        RCU_NOCB_CPU = yes;
        RCU_LAZY = yes;
      };
    }
  ];
}
