# CONTEXT.md — ClinicFlow

> Este arquivo é o ponto de partida para retomada de sessões com o Tech Lead (Claude).
> No início de cada sessão, cole o conteúdo deste arquivo no chat para restaurar o contexto completo do projeto.

---

## Sobre o projeto

**ClinicFlow** é um sistema web de gestão para clínicas de fisioterapia, desenvolvido como projeto de portfólio por um desenvolvedor júnior recém-formado em Engenharia da Computação. O objetivo é ter um produto distribuível, acessível via web com autenticação por usuário e senha.

---

## Dinâmica de trabalho

- O desenvolvedor é **junior**, com conhecimento básico de Java (POO) adquirido na faculdade
- O **Tech Lead** é o Claude (Anthropic) — auxilia com código, code review, dailys simuladas e decisões de arquitetura
- O processo segue **Scrum** com sprints de 2 semanas
- Toda sessão começa com uma **daily simulada**: o que foi feito, o que será feito, impedimentos
- Todo código passa por **Pull Request** antes de mergear em `develop`
- Commits seguem o padrão **Conventional Commits** (`feat:`, `fix:`, `docs:`, `test:`, etc.)

---

## Stack definida

| Camada | Tecnologia |
|---|---|
| Linguagem | Java 21 |
| Framework | Spring Boot 3.x |
| Segurança | Spring Security 6.x + JWT (jjwt 0.12.x) |
| ORM | Spring Data JPA + Hibernate 6.x |
| Banco de dados | PostgreSQL 16 |
| Migrations | Flyway 10.x |
| Build | Maven 3.x |
| Documentação API | Springdoc OpenAPI 2.x |
| Testes | JUnit 5 + Mockito + Spring Boot Test |
| Containers | Docker + Docker Compose |
| CI/CD | GitHub Actions |

---

## Git flow

```
main      ← produção (protegida, só via PR)
develop   ← integração (base de todas as features)
feature/nome-da-task  ← uma branch por task
hotfix/descricao      ← correção urgente
```

---

## Regras de negócio — resumo executivo

### Clínica
- 1 unidade no MVP, arquitetura preparada para multi-tenant
- Modelo particular no MVP, preparado para convênios futuros
- Serviços: **Fisioterapia** (interno + externo), **Pilates** (somente interno), **Terapias Manuais** (somente interno)

### Profissionais
- Horário misto: base fixa definida pela clínica + flexibilidade individual
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
- Atendimento externo registra endereço de destino
- Status possíveis: Agendado → Confirmado → Realizado | Cancelado | Falta
- Notificações automáticas fora do MVP

### Pacientes e prontuário
- Cadastro: nome, CPF, nascimento, sexo, telefone, e-mail, endereço
- Prontuário completo: anamnese inicial + evolução por sessão
- Evolução clínica **somente para fisioterapia** (não para Pilates nem Terapias Manuais)
- Recepcionista não acessa dados clínicos, somente dados cadastrais
- Upload de documentos fora do MVP

### Perfis de acesso
| Perfil | Agendamentos | Cadastro paciente | Prontuário | Configurações |
|---|---|---|---|---|
| Administrador | Total | Total | Total | Total |
| Recepcionista | Total | Somente cadastral | Sem acesso | Sem acesso |
| Profissional | Visualiza própria | Seus pacientes | Seus pacientes | Sem acesso |
| Paciente | — | — | — | — (futuro) |

### Relatórios
- Dashboard e relatórios gerenciais fora do MVP
- Controle financeiro fora do escopo

---

## Roadmap de sprints

| Sprint | Foco |
|---|---|
| Sprint 0 | Setup, Git flow, Docker, estrutura de pacotes, CI |
| Sprint 1 | Autenticação JWT, usuários, perfis de acesso |
| Sprint 2 | CRUD pacientes, prontuário, CRUD profissionais |
| Sprint 3 | Agendamentos, conflitos, turmas, pacotes, evolução clínica |
| Sprint 4 | Testes de integração, ajustes, deploy |

---

## Estrutura de pacotes Java

```
com.clinicflow/
├── config/       ← Security, OpenAPI, beans de configuração
├── controller/   ← endpoints REST
├── service/      ← regras de negócio
├── repository/   ← interfaces JPA
├── domain/       ← entidades JPA (modelos do banco)
├── dto/          ← request/response objects
├── exception/    ← exceções customizadas e handlers
└── mapper/       ← conversão entidade ↔ DTO
```

---

## Arquivos de documentação no repositório

```
docs/
├── project-overview.md   ← visão geral, stack, sprints, Git flow
├── business-rules.md     ← regras de negócio completas
└── CONTEXT.md            ← este arquivo
```

---

## Status atual do projeto

- [x] Levantamento de requisitos concluído
- [x] Regras de negócio documentadas
- [x] Stack tecnológica definida
- [x] Git flow definido
- [ ] Repositório criado no GitHub
- [ ] Sprint 0 iniciado

---

## Como usar este arquivo

Cole o conteúdo deste arquivo no início de cada sessão com o Tech Lead com a mensagem:

> "Continuando o projeto ClinicFlow. Aqui está o contexto: [conteúdo deste arquivo]"

O Tech Lead estará completamente situado em menos de 30 segundos.

## Status atual do projeto (atualizado)

- [x] Levantamento de requisitos concluído
- [x] Regras de negócio documentadas
- [x] Stack tecnológica definida
- [x] Git flow definido
- [x] Modelagem do banco de dados concluída
- [ ] User Stories geradas
- [ ] Repositório criado no GitHub
- [ ] Sprint 0 iniciado

---

## Modelagem do banco de dados

Diagrama ER concluído e salvo localmente como `clinicflow-er.drawio`.
Exportar como PNG e commitar em `docs/` no Sprint 0.

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

### Novas regras de negócio adicionadas na revisão
| ID | Regra |
|---|---|
| RN-02.1 | Profissional não pode alterar horários — somente visualizar |
| RN-03.9 | Agendamento externo usa endereço cadastrado do paciente |
| RN-04.6 | Endereço obrigatório para pacientes e profissionais — tabela separada compartilhável |
| RN-07.1 | Pilates possui 6 planos — combinações de duração e frequência semanal |
| RN-07.2 | Sistema preserva histórico de preços dos planos |
| RN-07.3 | Contratação de pacote registra o preço vigente no momento |
| RN-07.4 | Fisioterapia e Terapias Manuais não possuem planos no MVP |

### Ferramentas utilizadas
- Modelagem ER: draw.io (diagrams.net)
- IDE: IntelliJ IDEA