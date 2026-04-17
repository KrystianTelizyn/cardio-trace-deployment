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

## Repository Structure

```text
.
|-- Makefile
|-- docker-compose.yml
|-- docker-compose.dev.yml
|-- docker-compose.prod.yml
|-- versions.env.example
|-- envs/
|   |-- api.env.example
|   |-- gateway.env.example
|   |-- db.env.example
|   `-- iot-simulation.env.example
`-- data/
    `-- rr_config.json
```

## Services

Base stack (`docker-compose.yml`) defines:

- `api` (Cardio Trace backend API)
- `gateway` (edge/API gateway)
- `db` (PostgreSQL 17, persistent volume)
- `broker` (Eclipse Mosquitto MQTT broker)
- `iot-simulation` (simulated wearable telemetry publisher)

### Compose Layering Model

- `docker-compose.yml`: base service definitions and shared wiring
- `docker-compose.dev.yml`: local dev image tags and host port exposure
- `docker-compose.prod.yml`: AWS ECR image sources and prod-oriented tags

The `Makefile` combines files as:

- **Dev:** `docker-compose.yml` + `docker-compose.dev.yml`
- **Prod:** `docker-compose.yml` + `docker-compose.prod.yml`

## Prerequisites

- Docker + Docker Compose v2 (`docker compose`)
- GNU Make
- (Production image pulls) AWS CLI configured with permissions for ECR in `eu-north-1`

## Quick Start (Development)

1. Create local config files:

   ```bash
   make setup
   ```

2. Review and adjust generated files:
   - `versions.env`
   - `envs/api.env`
   - `envs/gateway.env`
   - `envs/db.env`
   - `envs/iot-simulation.env`

3. Start the dev stack:

   ```bash
   make dev
   ```

4. Stop when done:

   ```bash
   make dev-down
   ```

## Production Workflow

1. Create/update env files:

   ```bash
   make setup
   ```

2. Set production image versions in `versions.env`.
3. Authenticate Docker with ECR:

   ```bash
   make login
   ```

4. Pull images and start:

   ```bash
   make prod-pull
   make prod
   ```

5. Stop stack:

   ```bash
   make prod-down
   ```

## Environment Files

- `versions.env`: image tags used by compose interpolation (`API_VERSION`, `GATEWAY_VERSION`, `IOT_SIMULATION_VERSION`)
- `envs/api.env`: API runtime settings (DB connection, debug flags, allowed hosts, app secret)
- `envs/gateway.env`: gateway/auth/provider integration settings (Auth0, app URLs, RBAC mode)
- `envs/db.env`: PostgreSQL bootstrap credentials and database name
- `envs/iot-simulation.env`: simulator wiring (MQTT host/port, rr config path, records DB path)

## Data Assets

- `data/rr_config.json` defines IoT simulation device profiles, publish topics, frame intervals, and record tags.
- `data/rr_records.db` contains a small sample RR simulation dataset used by the IoT simulator for local/testing runs.

## Useful Make Targets

- `make help` - list available targets
- `make setup` - copy example env files into editable local files
- `make dev` / `make dev-down` - run or stop dev stack
- `make prod-pull` / `make prod` / `make prod-down` - production pull/start/stop
- `make logs` - follow base stack logs
- `make ps` - show container status
- `make login` - authenticate Docker to AWS ECR

## Notes

- `versions.env` and `envs/*.env` are git-ignored by design.
- Default example secrets are placeholders only; replace them for any shared or production environment.