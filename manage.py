#!/usr/bin/env python3
from __future__ import annotations

import shutil
import subprocess
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parent
ENV_FILE = ROOT / ".env"
ENV_EXAMPLE_FILE = ROOT / ".env.example"


def print_help() -> None:
    print("Uso: python manage.py <comando>")
    print("")
    print("Comandos:")
    print("  setup            Cria o arquivo .env a partir do .env.example")
    print("  up               Sobe o ambiente com Docker")
    print("  down             Para o ambiente")
    print("  restart          Reinicia o ambiente")
    print("  logs             Mostra os logs do n8n")
    print("  status           Mostra o status dos containers")
    print("  reset-output     Remove os arquivos gerados em output/")
    print("  import-workflow  Mostra qual workflow importar")


def ensure_docker() -> None:
    if shutil.which("docker") is None:
        print("Docker nao encontrado no sistema.")
        print("Instale o Docker Desktop ou Docker Engine antes de continuar.")
        sys.exit(1)


def ensure_env() -> None:
    if ENV_FILE.exists():
        print("Arquivo .env ja existe.")
        return
    shutil.copyfile(ENV_EXAMPLE_FILE, ENV_FILE)
    print("Arquivo .env criado com base em .env.example")
    print("Edite o arquivo .env e preencha seus dados do WhatsApp antes de subir o ambiente.")


def run_docker_compose(args: list[str]) -> int:
    ensure_docker()
    command = ["docker", "compose", *args]
    return subprocess.call(command, cwd=ROOT)


def reset_output() -> None:
    output_dir = ROOT / "output"
    output_dir.mkdir(exist_ok=True)
    removed = 0
    for pattern in ("*.json", "*.csv"):
        for file_path in output_dir.glob(pattern):
            file_path.unlink(missing_ok=True)
            removed += 1
    print(f"{removed} arquivo(s) removido(s) de output/.")


def main() -> int:
    if len(sys.argv) < 2:
        print_help()
        return 0

    command = sys.argv[1].lower()

    if command == "setup":
        ensure_env()
        return 0

    if command == "up":
        ensure_env()
        code = run_docker_compose(["up", "-d", "--build"])
        if code == 0:
            print("n8n iniciado em http://localhost:5679")
        return code

    if command == "down":
        return run_docker_compose(["down"])

    if command == "restart":
        ensure_env()
        code = run_docker_compose(["down"])
        if code != 0:
            return code
        return run_docker_compose(["up", "-d", "--build"])

    if command == "logs":
        return run_docker_compose(["logs", "-f", "n8n"])

    if command == "status":
        return run_docker_compose(["ps"])

    if command == "reset-output":
        reset_output()
        return 0

    if command == "import-workflow":
        print("Importe o arquivo workflows/WhatsApp-Contacts-Extractor-v3.json no n8n.")
        return 0

    print(f"Comando invalido: {command}")
    print("")
    print_help()
    return 1


if __name__ == "__main__":
    raise SystemExit(main())
