# ClinicFlow — Visão Geral do Projeto

> Sistema de gestão para clínicas de fisioterapia — SaaS web, acesso por usuário e senha.

---

## Identificação do projeto

| Campo | Valor |
|---|---|
| Nome | ClinicFlow |
| Tipo | SaaS Web — Sistema de gestão clínica |
| Segmento | Clínicas de fisioterapia |
| Modelo financeiro (MVP) | Particular |
| Unidades (MVP) | 1 unidade |
| Desenvolvedor Marcos Vinicius Moreira| Junior Dev |
| Tech Lead | Claude (Anthropic) |
| Versão do documento | 1.0 |

---

## Stack tecnológica

### Backend
| Tecnologia | Versão | Função |
|---|---|---|
| Java | 21 | Linguagem principal |
| Spring Boot | 3.x | Framework principal |
| Spring Security | 6.x | Autenticação e autorização |
| Spring Data JPA | 3.x | Camada de dados (ORM) |
| Hibernate | 6.x | Implementação JPA |
| JWT (jjwt) | 0.12.x | Tokens de autenticação |
| PostgreSQL | 16 | Banco de dados relacional |
| Flyway | 10.x | Versionamento de migrations |
| Maven | 3.x | Gerenciamento de dependências |
| Springdoc OpenAPI | 2.x | Documentação automática da API |

### Qualidade e testes
| Tecnologia | Função |
|---|---|
| JUnit 5 | Testes unitários |
| Mockito | Mocks em testes |
| Spring Boot Test | Testes de integração |

### Infra e DevOps
| Tecnologia | Função |
|---|---|
| Docker | Containerização da aplicação |
| Docker Compose | Orquestração local (app + banco) |
| GitHub Actions | Pipeline CI/CD |

---

### Modelo do banco de dados

![Diagrama ER do ClinicFlow](clinicflow-er.png)

## Justificativas técnicas das escolhas

### Por que PostgreSQL e não MySQL?
- Suporte superior a transações complexas (conflito de horários, controle de vagas em turmas)
- Tipo `JSONB` para evolução futura do prontuário sem quebrar schema
- Extensão `pgcrypto` para dados sensíveis de pacientes (LGPD)
- Maior adoção em empresas de médio/grande porte no mercado brasileiro

### Por que Spring Boot?
- Padrão do mercado corporativo brasileiro — maior volume de vagas
- Ecossistema maduro com Spring Security, Data JPA e OpenAPI integrados
- Comunidade e documentação extensas — essencial para um desenvolvedor junior

### Por que Flyway?
- Em ambientes reais o banco nunca é criado manualmente
- Cada alteração de schema é versionada como código no Git
- Garante consistência entre ambientes (local, staging, produção)

---

## Módulos do sistema (MVP)

### Agendamentos
- Sessões avulsas e pacotes de sessões
- Fisioterapia (interno e externo), Pilates (interno, turmas), Terapias Manuais (interno)
- Controle de conflitos de horário por profissional
- Controle de vagas em turmas de Pilates (máx. 6 por padrão)
- Status: Agendado, Confirmado, Realizado, Cancelado, Falta

### Pacientes
- Cadastro completo com dados pessoais
- Prontuário com anamnese inicial (fisioterapia)
- Evolução clínica por sessão (fisioterapia)
- Histórico de agendamentos

### Profissionais
- Cadastro com CREFITO
- Múltiplas especialidades por profissional
- Agenda com horário base + flexibilidade individual
- Habilitação para atendimento externo

---

## Perfis de acesso

| Perfil | Agendamentos | Pacientes (cadastro) | Prontuário clínico | Configurações |
|---|---|---|---|---|
| Administrador | ✅ Total | ✅ Total | ✅ Total | ✅ Total |
| Recepcionista | ✅ Total | ✅ Cadastral | ❌ Sem acesso | ❌ Sem acesso |
| Profissional | 👁️ Visualiza própria | 👁️ Seus pacientes | ✅ Seus pacientes | ❌ Sem acesso |
| Paciente | — | — | — | — |

> Perfil **Paciente** previsto para versão futura.

---

## Git flow

```
main          ← produção — protegida, somente via PR aprovado
  └── develop ← integração — base de todas as features
        ├── feature/nome-da-task   ← uma branch por task
        └── hotfix/descricao       ← correção urgente em produção
```

### Padrão de commits (Conventional Commits)
```
feat: adiciona cadastro de paciente
fix: corrige conflito de horário no agendamento
docs: atualiza regras de negócio
test: adiciona testes unitários para AgendamentoService
refactor: extrai validação de CPF para classe utilitária
chore: atualiza dependências do pom.xml
```

### Regras de branch
- Nenhum commit direto em `main` ou `develop`
- Todo merge via Pull Request com code review
- Branch deletada após merge aprovado
- Nome da branch em kebab-case: `feature/cadastro-paciente`

---

## Roadmap de sprints

| Sprint | Período | Entregáveis |
|---|---|---|
| Sprint 0 | Semanas 1–2 | Setup do projeto, Git flow, Docker, estrutura de pacotes, CI básico, documentação inicial |
| Sprint 1 | Semanas 3–4 | Autenticação JWT, cadastro de usuários, perfis de acesso (Admin, Recepcionista, Profissional) |
| Sprint 2 | Semanas 5–6 | CRUD de pacientes, prontuário, anamnese, CRUD de profissionais, especialidades |
| Sprint 3 | Semanas 7–8 | Agendamentos, controle de conflitos, turmas de Pilates, pacotes de sessões, evolução clínica |
| Sprint 4 | Semanas 9–10 | Testes de integração, ajustes finais, deploy em produção |

---

## Estrutura de pastas do projeto (padrão de mercado)

```
clinicflow/
├── docs/
│   ├── project-overview.md       ← este arquivo
│   ├── business-rules.md         ← regras de negócio
│   └── CONTEXT.md                ← contexto para retomada de sessões
├── src/
│   └── main/
│       └── java/
│           └── com/clinicflow/
│               ├── config/       ← configurações (Security, OpenAPI, etc.)
│               ├── controller/   ← endpoints REST
│               ├── service/      ← regras de negócio
│               ├── repository/   ← acesso ao banco (JPA)
│               ├── domain/       ← entidades JPA
│               ├── dto/          ← objetos de transferência de dados
│               ├── exception/    ← exceções customizadas
│               └── mapper/       ← conversão entre entidades e DTOs
├── src/
│   └── test/                     ← testes unitários e de integração
├── src/
│   └── main/
│       └── resources/
│           ├── application.yml   ← configurações da aplicação
│           └── db/migration/     ← scripts Flyway (V1__*, V2__*, ...)
├── docker-compose.yml            ← ambiente local
├── Dockerfile                    ← imagem da aplicação
├── pom.xml                       ← dependências Maven
└── README.md                     ← apresentação do projeto
```

---

## Escopo futuro (fora do MVP)

- Portal do paciente com auto-agendamento
- Convênios e planos de saúde
- Múltiplas unidades (multi-tenant)
- Notificações e lembretes automáticos
- Dashboard com indicadores de desempenho
- Controle financeiro e comissões
- Upload de documentos e exames
