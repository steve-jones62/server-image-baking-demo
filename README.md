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

Notes
	•	workflow_dispatch gives you a manual demo trigger.
	•	actions/upload-artifact preserves the qcow2 image and manifest after the run. GitHub documents artifacts as files produced by a workflow and recommends upload-artifact for storing them.  ￼
	•	Replace KNOWN_GOOD_CHECKSUM_HERE with the actual Ubuntu ISO checksum before running.

  Why this matters
	•	The QEMU builder is the part that creates the VM image. Packer documents that builder as creating KVM virtual machine images.  ￼
	•	The shell provisioner is where your baked baseline happens. Packer documents shell provisioners for installing and configuring software on the machine being built.  ￼
	•	The shell-local provisioner runs on the runner, not inside the guest. That is useful for local metadata generation.
  
