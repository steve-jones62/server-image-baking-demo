# server-image-baking-demo

Repo Layout
```
server-image-baking-demo/
├── .github/
│   └── workflows/
│       └── bake-image.yml
├── packer/
│   ├── ubuntu-kvm.pkr.hcl
│   ├── http/
│   │   └── user-data
│   └── scripts/
│       ├── baseline.sh
│       └── validate.sh
└── README.md
```


How the flow works
```
Manual workflow dispatch or Git push
  ↓
GitHub Actions
  ↓
packer init
  ↓
packer validate
  ↓
packer build
  ↓
QEMU temporary VM boots
  ↓
Packer shell provisioner runs baseline.sh
  ↓
Packer captures qcow2 image
  ↓
validate.sh runs against build outputs
  ↓
GitHub uploads qcow2 + manifest as artifacts
```

Packer uses builders to create a machine, provisioners to configure it after boot, and optional local steps can run on the build runner. GitHub Actions supports YAML workflows and artifact upload/download.
