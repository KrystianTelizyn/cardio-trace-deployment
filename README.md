Cardio Trace Deployment
===========================

**This is a part of [Cardio Trace Platform](https://github.com/KrystianTelizyn/cardio-trace-platform)**
Deployment workspace for the **Cardio Trace** platform in the polyrepo.
This repository focuses on container orchestration, environment configuration, and runtime operations (not application source code).

## Purpose

This project provides:

- shared Docker Compose base service definitions
- environment-specific overlays for development and production
- `.env` templates for each service
- Make targets for common operational tasks
- support files for IoT simulation data