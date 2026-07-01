# CONTEXT.md — ClinicaFisio.v2

> Este arquivo é o ponto de partida para retomada de sessões com o Tech Lead (Claude).
> No início de cada sessão, cole o conteúdo deste arquivo no chat para restaurar o contexto completo do projeto.

---

## Sobre o projeto

**ClinicaFisio.v2** é um sistema web de gestão para clínicas de fisioterapia, desenvolvido como projeto de portfólio por um desenvolvedor júnior recém-formado em Engenharia da Computação. O objetivo é ter um produto distribuível, acessível via web com autenticação por usuário e senha.

---

## Dinâmica de trabalho

- O desenvolvedor é **junior**, com conhecimento básico de Java (POO) adquirido na faculdade
- O **Tech Lead** é o Claude (Anthropic) — auxilia com código, code review, dailys simuladas e decisões de arquitetura
- O processo segue **Scrum** com sprints de 2 semanas
- Toda sessão começa com uma **daily simulada**: o que foi feito, o que será feito, impedimentos
- Todo código passa por **Pull Request** antes de mergear em `develop`
- Commits seguem o padrão **Conventional Commits** (`feat:`, `fix:`, `docs:`, `test:`, `chore:`, `refactor:`)

---

## Repositório

- **URL:** https://github.com/mvmmoreira/ClinicaFisio.v2
- **Branch principal:** main (protegida — somente via PR)
- **Branch de integração:** develop
- **Branch ativa atual:** develop

---

## Stack definida

| Camada | Tecnologia |
|---|---|
| Linguagem | Java 21 |
| Framework | Spring Boot 4.0.7 |
| Segurança | Spring Security 6.x + JWT |
| ORM | Spring Data JPA + Hibernate |
| Banco de dados | PostgreSQL 16 |
| Migrations | Flyway |
| Build | Maven |
| Documentação API | Springdoc OpenAPI |
| Testes | JUnit 5 + Mockito + Spring Boot Test |
| Containers | Docker + Docker Compose |
| CI/CD | GitHub Actions (pendente) |
| IDE | IntelliJ IDEA |
| Versionamento | Git + GitHub |

---

## Dependências configuradas no pom.xml

- Spring Web
- Spring Data JPA
- Spring Security
- PostgreSQL Driver
- Flyway Migration
- Lombok
- Validation
- Spring Boot DevTools

---

## Git flow

```
main      ← produção (protegida, só via PR)
develop   ← integração (base de todas as features)
feature/US-XX-descricao  ← uma branch por User Story
hotfix/descricao         ← correção urgente em produção
```

### Padrão de commits
```
feat:     nova funcionalidade
fix:      correção de bug
docs:     documentação
chore:    configuração e manutenção
test:     testes
refactor: refatoração sem mudar funcionalidade
```

---

## Regras de negócio — resumo executivo

### Clínica
- 1 unidade no MVP, arquitetura preparada para multi-tenant
- Modelo particular no MVP, preparado para convênios futuros
- Não é multi-tenant — uma única clínica usa o sistema
- Serviços: **Fisioterapia** (interno + externo), **Pilates** (somente interno), **Terapias Manuais** (somente interno)

### Profissionais
- Horário base definido e gerenciado exclusivamente pelo Administrador
- Profissional somente visualiza sua própria agenda — não pode alterar horários
- Multidisciplinares: um profissional pode ter múltiplas especialidades
- Todos habilitados para atendimento externo (desativável individualmente)
- CREFITO obrigatório no cadastro
- Controle financeiro/comissão fora do MVP

### Agendamentos
- Somente Administrador e Recepcionista criam/editam/cancelam agendamentos
- Tipos: avulso ou pacote de sessões (com controle de saldo)
- Sistema impede conflito de horário por profissional
- **Pilates em turma**: até 6 pacientes simultâneos por sessão
- **Fisioterapia e Terapias Manuais**: sempre individuais (1 paciente)
- Atendimento externo usa automaticamente o endereço cadastrado do paciente
- Status possíveis: Agendado → Confirmado → Realizado | Cancelado | Falta
- Notificações automáticas fora do MVP

### Pacientes e prontuário
- Cadastro: nome, CPF, nascimento, sexo, telefone, e-mail, endereço
- Prontuário completo: anamnese inicial + evolução por sessão
- Evolução clínica **somente para fisioterapia**
- Recepcionista não acessa dados clínicos, somente dados cadastrais
- Upload de documentos fora do MVP

### Endereço
- Tabela separada compartilhada entre Paciente e Profissional
- Cada pessoa tem exatamente 1 endereço obrigatório
- Vários pacientes/profissionais podem compartilhar o mesmo endereço

### Planos de Pilates
- 6 combinações: Mensal 2x, Mensal 3x, Trimestral 2x, Trimestral 3x, Semestral 2x, Semestral 3x
- Sistema preserva histórico de preços ao atualizar valor
- Contratação registra o preço vigente no momento

### Perfis de acesso
| Perfil | Agendamentos | Cadastro paciente | Prontuário | Agenda profissional | Configurações |
|---|---|---|---|---|---|
| Administrador | Total | Total | Total | Cria e edita | Total |
| Recepcionista | Total | Somente cadastral | Sem acesso | Sem acesso | Sem acesso |
| Profissional | Visualiza própria | Seus pacientes | Seus pacientes | Somente visualiza | Sem acesso |
| Paciente | — | — | — | — | — (futuro) |

### Relatórios
- Dashboard e relatórios gerenciais fora do MVP
- Controle financeiro fora do escopo

---

## Modelagem do banco de dados

Diagrama ER concluído e salvo em `docs/Clinicav2Modelagem.drawio.png`.

### Entidades fortes
- `Paciente`
- `Profissional`
- `TipoServico`

### Entidades fracas diretas
- `Endereco` — compartilhada entre Paciente e Profissional
- `Disponibilidade` — depende de Profissional
- `Prontuario` — depende de Paciente
- `Agendamento` — depende de Paciente, Profissional e TipoServico
- `Plano` — planos de Pilates
- `PacoteSessoes` — depende de Paciente, Plano e PlanoPreco
- `ProfissionalServico` — tabela intermediária N:N entre Profissional e TipoServico

### Entidades fracas de segundo nível
- `EvolucaoClinica` — depende de Prontuario
- `PlanoPreco` — depende de Plano

### Relacionamentos
| Relacionamento | Tipo |
|---|---|
| Endereco → Paciente | 1:N |
| Endereco → Profissional | 1:N |
| Profissional → Disponibilidade | 1:N |
| Paciente → Prontuario | 1:1 |
| Prontuario → EvolucaoClinica | 1:N |
| Paciente → Agendamento | 1:N |
| Profissional → Agendamento | 1:N |
| TipoServico → Agendamento | 1:N |
| Profissional → ProfissionalServico ← TipoServico | N:N |
| Plano → PacoteSessoes | 1:N |
| Paciente → PacoteSessoes | 1:N |
| Plano → PlanoPreco | 1:N |
| PlanoPreco → PacoteSessoes | 1:N |

### Decisões técnicas do banco
- Chave primária UUID em todas as entidades
- Soft delete com campo `ativo` em todas as entidades principais
- Campo `senha` sempre armazenado como hash BCrypt
- Campo `email` do Profissional é único — usado como login
- Tipos categóricos (status, dia_semana, modalidade) viram Enum no Java
- `NUMERIC(10,2)` para valores monetários
- `TEXT` para campos clínicos sem limite de tamanho

---

## Estrutura de pacotes Java

```
com.clinicafisio/
├── config/       ← Security, OpenAPI, beans de configuração
├── controller/   ← endpoints REST
├── service/      ← regras de negócio
├── repository/   ← interfaces JPA
├── domain/       ← entidades JPA (modelos do banco)
├── dto/          ← request/response objects
├── exception/    ← exceções customizadas e handlers
├── mapper/       ← conversão entidade ↔ DTO
└── ClinicafisioApplication.java
```

---

## Estrutura completa do projeto

```
ClinicaFisio.v2/
├── docs/
│   ├── CONTEXT.md
│   ├── project-overview.md
│   ├── business-rules.md
│   ├── user-stories.md
│   └── Clinicav2Modelagem.drawio.png
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/clinicafisio/
│   │   │       ├── config/
│   │   │       ├── controller/
│   │   │       ├── service/
│   │   │       ├── repository/
│   │   │       ├── domain/
│   │   │       ├── dto/
│   │   │       ├── exception/
│   │   │       ├── mapper/
│   │   │       └── ClinicafisioApplication.java
│   │   └── resources/
│   │       ├── db/migration/     ← scripts Flyway vão aqui
│   │       ├── static/
│   │       ├── templates/
│   │       └── application.yaml
│   └── test/
├── .env                          ← NÃO vai para o GitHub
├── .env.example                  ← vai para o GitHub (sem valores)
├── .gitignore
├── .gitattributes
├── docker-compose.yml
├── mvnw
├── mvnw.cmd
├── pom.xml
└── README.md
```

---

## Configurações importantes

### docker-compose.yml
```yaml
services:
  postgres:
    image: postgres:16
    container_name: clinicafisio.db
    env_file:
      - .env
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
```

### .env (não vai para o GitHub)
```env
DB_HOST=localhost
DB_PORT=5432
DB_NAME=clinicafisio
DB_USER=clinicafisio
DB_PASSWORD=clinicafisio123
```

### application.yaml
```yaml
spring:
  application:
    name: clinicafisio

  datasource:
    url: jdbc:postgresql://${DB_HOST}:${DB_PORT}/${DB_NAME}
    username: ${DB_USER}
    password: ${DB_PASSWORD}
    driver-class-name: org.postgresql.Driver

  jpa:
    hibernate:
      ddl-auto: validate
    show-sql: true
    properties:
      hibernate:
        format_sql: true
        dialect: org.hibernate.dialect.PostgreSQLDialect

  flyway:
    enabled: true
    locations: classpath:db/migration
    baseline-on-migrate: true

server:
  port: 8080
```

---

## Ferramentas instaladas na máquina

| Ferramenta | Status |
|---|---|
| Git Bash | ✅ Instalado |
| IntelliJ IDEA | ✅ Instalado |
| Java 21 | ✅ Instalado |
| Docker Desktop 29.5.3 | ✅ Instalado |
| Docker Compose v5.1.4 | ✅ Instalado |

---

## Run Configuration no IntelliJ

Para rodar a aplicação no IntelliJ as variáveis de ambiente precisam estar configuradas:

- Abre **Run → Edit Configurations**
- Em **Environment variables** aponta para o arquivo `.env`
- Caminho: `C:\ClinicaFisio.v2\ClinicaFisio.v2\.env`

---

## Roadmap de sprints

| Sprint | Foco | Status |
|---|---|---|
| Sprint 0 | Setup, Git flow, Docker, estrutura de pacotes | ✅ Concluído |
| Sprint 1 | Autenticação JWT, usuários, perfis de acesso | 🔄 Próximo |
| Sprint 2 | CRUD pacientes, prontuário, CRUD profissionais | ⬜ Pendente |
| Sprint 3 | Agendamentos, conflitos, turmas, pacotes, evolução clínica | ⬜ Pendente |
| Sprint 4 | Testes de integração, ajustes, deploy | ⬜ Pendente |

---

## Status atual do projeto

- [x] Levantamento de requisitos concluído
- [x] Regras de negócio documentadas
- [x] Stack tecnológica definida
- [x] Git flow definido
- [x] Modelagem do banco de dados concluída
- [x] User Stories geradas (17 stories em 3 sprints)
- [x] Board no Trello configurado
- [x] Repositório criado no GitHub
- [x] Branch develop criada e branch main protegida
- [x] Documentação commitada na develop (docs/)
- [x] Projeto Spring Boot 4.0.7 gerado
- [x] Estrutura de pacotes criada
- [x] .gitignore atualizado para Java + IntelliJ + Spring
- [x] Docker Desktop instalado e funcionando
- [x] docker-compose.yml criado com PostgreSQL 16
- [x] application.yaml configurado com variáveis de ambiente
- [x] .env criado com credenciais locais
- [x] .env.example criado e commitado no GitHub
- [x] Container PostgreSQL rodando na porta 5432
- [x] Aplicação Spring Boot subindo com sucesso na porta 8080
- [ ] Sprint 1 iniciado

---

## Próxima sessão — começa aqui

**Passo 1** — Subir o Docker e a aplicação
```bash
cd /c/ClinicaFisio.v2/ClinicaFisio.v2
docker-compose up -d
```
Depois rodar a aplicação no IntelliJ pelo botão ▶ Play.

**Passo 2** — Criar branch do Sprint 1
```bash
git checkout -b feature/US-01-autenticacao
```

**Passo 3** — Criar primeira migration Flyway
- Criar arquivo `V1__criar_tabela_usuario.sql` em `src/main/resources/db/migration`
- Início do Sprint 1 — autenticação JWT

---

## Ferramentas de gestão

| Ferramenta | Uso | Status |
|---|---|---|
| Trello | Board com User Stories organizadas por sprint | ✅ Configurado |
| GitHub Projects | Substituirá o Trello após Sprint 0 | ⬜ Pendente |

---


