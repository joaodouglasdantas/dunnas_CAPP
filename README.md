<p align="center">
  <img src="https://raw.githubusercontent.com/joaodouglasdantas/dunnas_CAPP/main/app/assets/images/favicon.svg" alt="Capp Logo" width="200"/>
</p>

# Capp — Sistema de Gerenciamento de Chamados para Condomínio

> Desafio Técnico Nº 0004/2026 — Dunnas

Sistema web desenvolvido em Ruby on Rails para gerenciamento de chamados em condomínios, com controle de acesso por papéis (RBAC), log de auditoria, arquivamento automático e deploy em produção.

🌐 **Sistema em produção:** https://meu-sistema-rails.onrender.com/

---

## Stack

- Ruby on Rails 8.1.3
- PostgreSQL
- Docker + Docker Compose
- Tailwind CSS v4
- Devise + RBAC manual
- Active Storage + Cloudflare R2
- Solid Queue + Solid Cache
- Minitest + Capybara (TDD)

---

## Como rodar

1. Clone o repositório
2. Copie `.env.example` para `.env` e preencha as variáveis
3. Execute `docker compose up --build`
4. Em outro terminal, crie e migre o banco:
```bash
docker compose exec web rails db:create db:migrate db:seed
```
5. Acesse `http://localhost:3000`

---

## Credenciais iniciais

- Email: admin@capp.com
- Senha: admin123

---

## Funcionalidades

- Cadastro de blocos com geração automática de unidades
- Três perfis: Administrador, Colaborador e Morador
- Chamados com tipos, status, SLA e anexos
- Comentários e histórico de interações
- Filtros avançados de chamados
- Log de auditoria completo
- Arquivamento automático de chamados concluídos há +30 dias
- Dashboard personalizado por perfil
- Interface responsiva com tema escuro/claro

---

## Testes

```bash
docker compose exec web rails test
```

---

## Solução de Problemas

```bash
# Erro ao subir a aplicação pela segunda vez — limpe o cache do Docker
docker builder prune -a

# Erro de volume do Docker
docker compose down -v
docker compose exec web rails db:create db:migrate RAILS_ENV=test

# Restart da aplicação
docker compose restart web
```

---

## Documentação completa

A documentação técnica completa está disponível em: `Documentacao_Capp.pdf ou Documentacao_Capp.docx`

---

> ⚠️ O sistema está hospedado no Render (plano gratuito) e pode demorar entre 30 e 60 segundos para responder na primeira tentativa de acesso do dia.