### Edit: Now an intervention-less boot works and this doesn't and I don't know what to believe in this world anymore
---
# Booting Alpine Linux on VMware

1. Use `alpine-virt` iso
2. Capture input in VM as soon as you boot
3. When the `ISOLINUX` `boot:` prompt shows up, type in `virt`, resulting in:

```
ISOLINUX [VERSION NO.] ETCD Copyright (C) 1994-20XX H. Peter Anvin et al
boot: virt
```

4. Press enter and proceed with your Alpine install
