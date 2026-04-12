## Como rodar

1. Clone o repositório
2. Copie `.env.example` para `.env` e preencha as variáveis
3. Execute `docker compose up --build`
4. Acesse `http://localhost:3000`

## Credenciais iniciais
- Email: admin@capp.com
- Senha: admin123

## Observação
- Caso seu codigo apresente erro ao subir a aplicação pela segunda vez, limpe o cache de construção do Docker usando `docker builder prune -a`