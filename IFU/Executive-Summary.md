# Executive Summary – IFU for .NET nanoFramework

## Purpose

This proposal defines the recommended approach to add In-Field Update (IFU) capabilities to .NET nanoFramework in a robust and maintainable way, suitable for long-lived embedded products.

.NET nanoFramework already enables managed C# applications on constrained embedded devices, including IoT and industrial scenarios. Adding a production-grade IFU workflow is a key step to make the platform a stronger alternative for professional embedded deployments, where remote lifecycle management is now a standard expectation.

## Background and investigated approaches

A range of update approaches were considered, including:

- extending the current in-house nanoBooter-based model
- leveraging vendor-specific OTA stacks where available (for example TI CC3220)
- evaluating established open-source and commercial-style update/bootloader ecosystems with proven upgrade and rollback semantics

After reviewing the available options, Mcuboot (MCUboot | mcuboot) emerged as the strongest baseline for the general nanoFramework IFU path.

Mcuboot is a mature secure bootloader for 32-bit microcontrollers, with a long release history and a portable design (OS-agnostic and hardware-independent via porting layers). It defines a common bootloader/system flash layout model and is specifically designed to support secure software upgrades.

It is also backed and used across major industry ecosystems, including:

- the Trusted Firmware ecosystem (Arm-focused secure software stack), where MCUboot is part of the project landscape; and
- Zephyr, where MCUboot and mcumgr are integrated into the device management and image update workflows.

This does not mean forcing MCUboot onto every nanoFramework target. For platforms where a vendor-native OTA path is better (e.g., TI CC3220), that path should remain the preferred option. TI’s OTA documentation already supports cloud-based update flows and references providers such as GitHub and Dropbox.

In case of Espressif devices whre there is a native support, Over The Air Updates (OTA) - ESP32 - — ESP-IDF Programming Guide v5.5.3 documentation, MCUboot is still the prefered path as it is more complete and anyway relies on the IDF mechanism.

## Proposed approach and high-level architecture

### 1) Bootloader and image lifecycle foundation (Mcuboot)

For supported targets, replace nanoBooter with Mcuboot.

MCUboot will provide:

- image validation/authentication
- pending/test/permanent upgrade flows
- rollback/revert behavior
- a standard slot-based upgrade model

This removes the need to re-implement complex boot/update state handling in-house and gives the project a stronger technical baseline for IFU. MCUboot’s design also separates core boot logic into bootutil, which is useful for reuse and testing.

### 2) Device transport and update control (mcumgr / SMP)

Use mcumgr/SMP as the management transport and command layer, initially focusing on serial transports (UART / USB CDC), while keeping BLE/UDP as supported future paths on capable targets.

mcumgr support for image management and multiple transports, matching the intended usage model for nanoFramework devices.

nanoFramework-specific extensions will be required, especially around:

- managed application image/deployment handling
- deployment region management
- workflow integration with the existing tooling and developer experience

### 3) Host-side tooling refactor (nanoFirmwareFlasher evolution)

The existing nanoFirmwareFlasher / nanoff flow must be refactored to support the MCUboot + mcumgr stack.

Today, nanoff already handles flashing firmware and deployment images and integrates multiple platform-specific tools. The proposed IFU work should evolve this into a reusable library-first component, then expose it through:

- nanoff
- Visual Studio integration
- VS Code integration

This will also allow use in internal/company-specific automation tools and CLIs, similar to what is happening today with the nanoff library.

This is especially important for ESP32, where current IFU-related flows rely on esptool assumptions that would be replaced in the new architecture.

### 4) Update retrieval component (connected IFU)

In addition to bootloader integration, a separate component is required to retrieve update artifacts for connected devices (both firmware/CLR payloads and managed application payloads).

This component should be designed with a provider abstraction, avoiding tight coupling to proprietary platform features where reasonable. Candidate initial providers include:

- GitHub
- Azure Storage
- Azure Device Update
- Dropbox

The goal is a generic and extensible API so the same IFU architecture can be used with different content delivery providers. Practical to use would be GitHub or Dropbox delivery in embedded workflows.

### 5) Optional managed C# IFU API

A minimal managed API should expose IFU state and control to C# applications when needed, for example:

- query IFU status
- trigger checks/downloads
- request install
- inspect progress / result

This is optional by design. On many devices, IFU can run autonomously in the background using a preconfigured policy.

This aligns with nanoFramework’s managed deployment model and keeps the architecture flexible across device classes.

## Platform scope and expected limitations

Primary focus (from MVP): ESP32 and STM32 families, so the initial delivery already covers the two most relevant platform lines for current and prospective adopters.

- **ESP32:** MCUboot already has an Espressif port, but it is HAL/platform dependent and tied to specific environment assumptions (including ESP-IDF alignment), so compatibility work is expected.
- **STM32:** integration/porting work is expected for the nanoFramework combinations in use (including RTOS-specific work for FreeRTOS/ChibiOS targets).

**Exceptions:** platforms with stronger vendor-native OTA/update stacks (e.g., TI CC3220) should keep those paths instead of forcing a single mechanism across all targets.

Not all currently supported nanoFramework targets will need the full autonomous IFU feature set. That is acceptable. Smaller devices can continue to use local update methods (JTAG, serial, Wire Protocol workflows) where IFU is not technically appropriate.

## Expected work split and likely challenges

### A. Bootloader integration and platform ports (largest work package)

- MCUboot integration with nanoFramework memory layout/build flow
- ESP32 integration and ESP-IDF compatibility alignment
- STM32 platform/RTOS integration (including FreeRTOS/ChibiOS variants)
- image signing and key/toolchain integration

**Likely issues**

- platform/HAL compatibility drift (especially ESP32)
- flash partition/slot layout edge cases
- validation of rollback behavior under reset/power-fail scenarios
- upstreaming and maintenance of platform-specific changes

### B. Host tooling and developer workflow integration

- refactor nanoff for MCUboot/MCUmgr workflows
- extract reusable library layer
- keep CLI and IDE workflows stable and easy to use

**Likely issues**

- migration impact on existing tooling flows
- cross-platform behavior (Windows/macOS/Linux)
- compatibility with existing deployment patterns

### C. Update retrieval/provider abstraction

- provider-neutral API and metadata/package contract
- first provider implementations
- auth/token handling
- retries, partial downloads, and constrained storage handling

**Likely issues**

- provider API differences
- storage/network limitations on smaller devices

### D. Managed API/runtime integration

- minimal C# IFU control/status API
- managed deployment region handling

**Likely issues**

- balancing API simplicity with usefulness across multiple targets

### E. Validation, documentation, and hardening

- test matrix for upgrade/revert/recovery paths
- docs for users and integrators
- reference workflows and examples

## Developer workload estimate

The work required to deliver IFU with the expected quality and within a useful timeframe is well beyond a best-effort / spare-time effort. It requires a funded delivery approach.

The figures below are rough estimates (best guess) based on the currently foreseeable scope and integration points. Actual effort may vary depending on platform-specific issues found during implementation.

## Estimated effort

- **MVP** (ESP32 + STM32, MCUboot/MCUmgr core flow, tooling integration, basic connected IFU path): **14–20 developer-weeks**
- **Phase 1** (MVP hardening + reusable tooling library + provider abstraction expansion + managed API + broader validation/docs): **18–26 developer-weeks**

These estimates assume focused work by experienced contributors familiar with nanoFramework internals and embedded platform/toolchain integration.

## Delivery model and funding approach

This is a project-level initiative that will benefit both the wider nanoFramework community and commercial users, but the implementation work itself is specialised and not suitable for a general “best effort” community contribution model.

### Delivery approach

- execution led by core contributors involved in nanoFramework internals/tooling
- phased delivery (MVP first, then hardening and expansion)
- work tracked and managed under core team coordination

### Funding and contribution options

We are actively looking for funding partners to support this work. Two contribution models are possible:

#### Direct funding sponsorship

Companies sponsor part or all of the work, and invoices are issued for the funded effort.

#### In-kind engineering contribution

Companies may allocate developer time from their own teams for specific tasks/work packages, coordinated and managed by the relevant nanoFramework core team members.

This allows organisations to support the IFU roadmap in the way that best fits their internal constraints, while keeping architecture and delivery aligned.

## Project impact

Adding IFU to .NET nanoFramework is a strategic technical step for the project:

- it closes an important capability gap for deployed embedded systems
- it improves maintainability and lifecycle management of devices in the field
- it strengthens the platform’s position for commercial and industrial adoption
- it builds on established embedded update practices rather than duplicating complex infrastructure in-house

In practice, this work moves nanoFramework from a strong embedded development platform to a more complete deployment-ready option for real-world connected products.
