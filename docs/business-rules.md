# ClinicFlow — Regras de Negócio

---

## Identificação

| Campo | Valor |
|---|---|
| Projeto | ClinicFlow |
| Versão | 1.0 |
| Status | Aprovado |
| Tipo de clínica | Fisioterapia |

### Legenda de escopo

| Marcador | Significado |
|---|---|
| `[MVP]` | Implementado no escopo atual |
| `[FUTURO]` | Arquitetura preparada, não implementado agora |
| `[FORA]` | Fora do escopo do produto |

---

## RN-01 · Clínica e estrutura

| ID | Regra | Escopo |
|---|---|---|
| RN-01.1 | O sistema gerencia uma única unidade clínica no MVP. A arquitetura deve suportar múltiplas unidades (multi-tenant) em versões futuras sem refatoração estrutural. | `[FUTURO]` |
| RN-01.2 | A clínica opera exclusivamente no modelo particular no MVP. O sistema deve ser projetado para integrar convênios e planos de saúde futuramente. | `[FUTURO]` |
| RN-01.3 | Os tipos de serviço oferecidos são: **Fisioterapia** (interno e externo), **Pilates** (somente interno) e **Terapias Manuais** (somente interno). | `[MVP]` |

---

## RN-02 · Profissionais

| ID | Regra | Escopo |
|---|---|---|
| RN-02.1 | Cada profissional possui um horário base cadastrado e gerenciado exclusivamente pelo Administrador. O profissional pode apenas visualizar sua própria agenda. `[MVP]`
| RN-02.2 | Um profissional pode ser habilitado para múltiplos tipos de serviço simultaneamente. Ex: um fisioterapeuta pode também ministrar Pilates e realizar Terapias Manuais. | `[MVP]` |
| RN-02.3 | Todos os profissionais estão habilitados a realizar atendimentos externos (domiciliar). A habilitação pode ser desativada individualmente pelo administrador. | `[MVP]` |
| RN-02.4 | O controle de comissão e repasse financeiro por atendimento está fora do escopo do MVP. A arquitetura deve permitir sua adição futura sem impacto nos módulos de agendamento. | `[FUTURO]` |
| RN-02.5 | Todo profissional deve ter seu número de CREFITO registrado no sistema. | `[MVP]` |
| RN-02.6 — Profissionais possuem obrigatoriamente um endereço vinculado. O endereço é armazenado em entidade própria e pode ser compartilhado entre múltiplos pacientes e profissionais . Cada pessoa possui exatamente um endereço. [MVP]

---

## RN-03 · Agendamentos

| ID | Regra | Escopo |
|---|---|---|
| RN-03.1 | Somente usuários com perfil **Administrador** ou **Recepcionista** podem criar, editar e cancelar agendamentos. | `[MVP]` |
| RN-03.2 | Um agendamento pode ser do tipo **avulso** (sessão única) ou vinculado a um **pacote de sessões** pré-definido. O pacote controla o saldo de sessões restantes. | `[MVP]` |
| RN-03.3 | O sistema deve impedir agendamentos em conflito para o mesmo profissional no mesmo horário, independente do tipo de serviço. | `[MVP]` |
| RN-03.4 | Sessões de **Pilates** podem ter múltiplos pacientes simultâneos (turma). A capacidade máxima da turma é definida por sala/equipamento, com limite padrão de 6 pessoas. | `[MVP]` |
| RN-03.5 | Sessões de **Fisioterapia** e **Terapias Manuais** são sempre individuais — 1 paciente por profissional por horário. | `[MVP]` |
| RN-03.6 | Atendimentos externos devem registrar o endereço de destino. O sistema não realiza cálculo de deslocamento ou roteirização no MVP. | `[MVP]` |
| RN-03.7 | O status de um agendamento pode ser: **Agendado**, **Confirmado**, **Realizado**, **Cancelado** e **Falta**. | `[MVP]` |
| RN-03.8 | Notificações e lembretes automáticos para o paciente estão fora do escopo do MVP. | `[FUTURO]` |
|RN-03.9 — Agendamentos do tipo externo utilizam automaticamente o endereço cadastrado do paciente. Não é permitido informar um endereço diferente no MVP. [MVP]

---

## RN-04 · Pacientes e prontuário

| ID | Regra | Escopo |
|---|---|---|
| RN-04.1 | O cadastro do paciente deve conter: nome completo, CPF, data de nascimento, sexo, telefone, e-mail e endereço completo. | `[MVP]` |
| RN-04.2 | Todo paciente de fisioterapia possui um prontuário com **anamnese inicial** (queixa principal, histórico clínico, medicamentos em uso) preenchida no primeiro atendimento. | `[MVP]` |
| RN-04.3 | Após cada sessão de **fisioterapia**, o profissional responsável deve registrar uma **evolução clínica** (texto livre + data + profissional). Pilates e Terapias Manuais não possuem evolução por sessão. | `[MVP]` |
| RN-04.4 | Upload de documentos, laudos e exames está fora do escopo do MVP. A estrutura do prontuário deve suportar sua adição futura. | `[FUTURO]` |
| RN-04.5 | O prontuário e as evoluções clínicas são de acesso restrito ao profissional responsável e ao administrador. Recepcionista não visualiza dados clínicos, somente dados cadastrais. | `[MVP]` |
| RN-04.6 — Pacientes possuem obrigatoriamente um endereço vinculado. O endereço é armazenado em entidade própria e pode ser compartilhado entre múltiplos pacientes . Cada pessoa possui exatamente um endereço. [MVP]

---

## RN-05 · Perfis de acesso

| ID | Regra | Escopo |
|---|---|---|
| RN-05.1 | **Administrador** — acesso total ao sistema: gerencia usuários, profissionais, pacientes, agendamentos e configurações da clínica. | `[MVP]` |
| RN-05.2 | **Recepcionista** — gerencia pacientes (dados cadastrais) e agendamentos. Sem acesso a dados clínicos, prontuários, evoluções ou configurações do sistema. | `[MVP]` |
| RN-05.3 | **Profissional** — visualiza sua própria agenda, acessa prontuários e registra evoluções dos seus pacientes. Não cria nem cancela agendamentos. | `[MVP]` |
| RN-05.4 | **Paciente** — perfil previsto para versão futura. Permitirá visualização de agendamentos e histórico próprio via portal ou app. | `[FUTURO]` |
| RN-05.5 | O acesso ao sistema é exclusivamente via autenticação com e-mail e senha. A sessão é gerenciada por token JWT com tempo de expiração configurável. | `[MVP]` |

---

## RN-06 · Relatórios e dashboard

| ID | Regra | Escopo |
|---|---|---|
| RN-06.1 | Dashboard com indicadores de desempenho (taxa de ocupação, faltas, atendimentos por período) está fora do escopo do MVP. | `[FUTURO]` |
| RN-06.2 | Controle financeiro, faturamento e relatórios gerenciais estão fora do escopo do MVP. | `[FORA]` |

---

## RN-06 · Relatórios e dashboard

| ID | Regra | Escopo |
|RN-07.1 — O serviço de Pilates possui planos com duração (mensal, trimestral, semestral) e modalidade (2x ou 3x por semana), totalizando 6 combinações de planos. [MVP]
|RN-07.2 — Cada plano possui um valor vigente. O administrador pode atualizar o valor a qualquer momento, mas o sistema preserva o histórico de preços anteriores com a data de vigência. [MVP]
|RN-07.3 — Ao contratar um pacote, o sistema registra qual preço estava vigente no momento da contratação. [MVP]
RN-07.4 — Fisioterapia e Terapias Manuais não possuem planos no MVP. [MVP]

## Resumo de decisões de escopo

### O que entra no MVP
- Gestão de 1 unidade, modelo particular
- 3 tipos de serviço: Fisioterapia, Pilates e Terapias Manuais
- Agendamentos avulsos e por pacote, com controle de conflitos
- Pilates em turma (até 6 pessoas)
- Atendimento externo para todos os profissionais
- Prontuário completo com anamnese e evolução (somente fisioterapia)
- 3 perfis de acesso: Administrador, Recepcionista e Profissional
- Autenticação via JWT

### O que fica para versões futuras
- Multi-unidade (multi-tenant)
- Convênios e planos de saúde
- Portal do paciente (perfil Paciente)
- Notificações e lembretes automáticos
- Dashboard e relatórios gerenciais
- Controle financeiro e comissões
- Upload de documentos e exames

---

> **Nota:** Qualquer funcionalidade não listada neste documento é considerada fora do escopo do MVP e deve passar por novo levantamento de requisitos antes de ser implementada.
