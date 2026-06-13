# ClinicFlow — User Stories

> Documento construído com base nas regras de negócio levantadas com o cliente.
> Organizado por sprint seguindo a cadeia de dependências técnicas.

---

## Legenda

| Símbolo | Significado |
|---|---|
| ✅ | Critério de sucesso |
| ❌ | Critério de erro |
| 🔒 | Restrição de perfil |

---

## Sprint 1 — Autenticação e Usuários

---

### US-01 — Login no sistema

> *Como administrador, recepcionista ou profissional, quero realizar login com e-mail e senha, para acessar o sistema com segurança.*

**Critérios de aceitação:**
- ✅ Sistema aceita e-mail e senha como credenciais
- ✅ Sistema retorna token JWT em caso de sucesso
- ✅ Token JWT expira após tempo configurável
- ✅ Sistema redireciona o usuário para a tela correspondente ao seu perfil após login
- ❌ Sistema exibe mensagem de erro se e-mail não encontrado
- ❌ Sistema exibe mensagem de erro se senha incorreta
- ❌ Sistema bloqueia acesso se campos estiverem vazios

---

### US-02 — Cadastro de profissional

> *Como administrador ou recepcionista, quero cadastrar profissionais no sistema, para viabilizar agendamentos e controlar o quadro de funcionários da clínica.*

**Critérios de aceitação:**
- ✅ Sistema aceita os dados: nome, CPF, CREFITO, telefone, endereço, e-mail, senha, atende_externo, ativo
- ✅ Sistema valida se CPF já está cadastrado
- ✅ Sistema valida se e-mail já está cadastrado
- ✅ Sistema armazena senha como hash BCrypt — nunca em texto puro
- ✅ Sistema vincula obrigatoriamente um endereço ao profissional
- 🔒 Apenas Administrador e Recepcionista acessam essa funcionalidade
- ❌ Sistema exibe erro se CPF já cadastrado
- ❌ Sistema exibe erro se e-mail já cadastrado
- ❌ Sistema exibe erro se campos obrigatórios não preenchidos
- ❌ Sistema exibe erro se CREFITO não informado

---

### US-03 — Cadastro de paciente

> *Como administrador ou recepcionista, quero cadastrar pacientes no sistema, para registrar seus dados antes do primeiro atendimento.*

**Critérios de aceitação:**
- ✅ Sistema aceita os dados: nome, CPF, data de nascimento, sexo, telefone, e-mail, endereço, ativo
- ✅ Sistema valida se CPF já está cadastrado
- ✅ Sistema valida se e-mail já está cadastrado
- ✅ Sistema vincula obrigatoriamente um endereço ao paciente
- ✅ Sistema registra data de cadastro automaticamente
- 🔒 Apenas Administrador e Recepcionista acessam essa funcionalidade
- ❌ Sistema exibe erro se CPF já cadastrado
- ❌ Sistema exibe erro se e-mail já cadastrado
- ❌ Sistema exibe erro se campos obrigatórios não preenchidos

---

### US-04 — Cadastro de tipo de serviço

> *Como administrador, quero cadastrar os tipos de serviço oferecidos pela clínica, para que possam ser vinculados aos agendamentos e profissionais.*

**Critérios de aceitação:**
- ✅ Sistema aceita os dados: nome, modalidade (INTERNO, EXTERNO, AMBOS), duração em minutos, ativo
- ✅ Sistema valida se já existe um serviço com o mesmo nome
- ✅ Modalidade deve ser um dos valores válidos: INTERNO, EXTERNO ou AMBOS
- 🔒 Apenas Administrador acessa essa funcionalidade
- ❌ Sistema exibe erro se nome já cadastrado
- ❌ Sistema exibe erro se modalidade inválida
- ❌ Sistema exibe erro se campos obrigatórios não preenchidos

---

## Sprint 2 — Cadastros e Prontuário

---

### US-05 — Editar profissional

> *Como administrador ou recepcionista, quero editar os dados de um profissional cadastrado, para manter as informações sempre atualizadas.*

**Critérios de aceitação:**
- ✅ Sistema permite alterar todos os dados exceto CPF
- ✅ Sistema valida se novo e-mail já está em uso por outro profissional
- ✅ Sistema registra data da última atualização
- 🔒 Apenas Administrador e Recepcionista acessam essa funcionalidade
- ❌ Sistema exibe erro se e-mail já cadastrado para outro profissional
- ❌ Sistema exibe erro se campos obrigatórios forem apagados

---

### US-06 — Editar paciente

> *Como administrador ou recepcionista, quero editar os dados de um paciente cadastrado, para manter as informações sempre atualizadas.*

**Critérios de aceitação:**
- ✅ Sistema permite alterar todos os dados exceto CPF
- ✅ Sistema valida se novo e-mail já está em uso por outro paciente
- ✅ Sistema registra data da última atualização
- 🔒 Apenas Administrador e Recepcionista acessam essa funcionalidade
- ❌ Sistema exibe erro se e-mail já cadastrado para outro paciente
- ❌ Sistema exibe erro se campos obrigatórios forem apagados

---

### US-07 — Cadastro de disponibilidade do profissional

> *Como administrador, quero cadastrar os dias e horários de trabalho de cada profissional, para que o sistema saiba quando eles estão disponíveis para agendamentos.*

**Critérios de aceitação:**
- ✅ Sistema aceita os dados: profissional, dia da semana, hora início, hora fim
- ✅ Sistema valida se já existe disponibilidade cadastrada para o mesmo profissional no mesmo dia
- ✅ Sistema valida se hora fim é maior que hora início
- ✅ Um profissional pode ter múltiplos registros de disponibilidade (um por dia da semana)
- 🔒 Apenas Administrador acessa essa funcionalidade
- ❌ Sistema exibe erro se hora fim menor ou igual à hora início
- ❌ Sistema exibe erro se já existe disponibilidade para aquele dia

---

### US-08 — Visualizar agenda própria

> *Como profissional, quero visualizar minha agenda de agendamentos, para me organizar e me preparar para os atendimentos do dia.*

**Critérios de aceitação:**
- ✅ Sistema exibe apenas os agendamentos do profissional logado
- ✅ Sistema permite filtrar por data
- ✅ Sistema exibe: paciente, tipo de serviço, horário, status e tipo de atendimento
- 🔒 Profissional visualiza apenas sua própria agenda — nunca a de outros
- ❌ Sistema exibe mensagem se não houver agendamentos no período selecionado

---

### US-09 — Abertura de prontuário

> *Como profissional, quero abrir o prontuário de um paciente de fisioterapia, para registrar a anamnese inicial antes do primeiro atendimento.*

**Critérios de aceitação:**
- ✅ Sistema aceita os dados: queixa principal, histórico clínico, medicamentos em uso
- ✅ Sistema vincula o prontuário ao paciente automaticamente
- ✅ Sistema registra data de abertura automaticamente
- ✅ Sistema impede abertura de segundo prontuário para o mesmo paciente
- 🔒 Apenas o profissional responsável e o Administrador acessam o prontuário
- 🔒 Recepcionista não visualiza dados do prontuário
- ❌ Sistema exibe erro se paciente já possui prontuário aberto

---

### US-10 — Registro de evolução clínica

> *Como profissional, quero registrar a evolução clínica após cada sessão de fisioterapia, para documentar o progresso do paciente ao longo do tratamento.*

**Critérios de aceitação:**
- ✅ Sistema aceita descrição em texto livre
- ✅ Sistema registra data e profissional responsável automaticamente
- ✅ Sistema vincula a evolução ao prontuário do paciente
- ✅ Evoluções são exibidas em ordem cronológica no prontuário
- 🔒 Apenas o profissional responsável e o Administrador visualizam as evoluções
- 🔒 Disponível somente para sessões de Fisioterapia
- ❌ Sistema exibe erro se paciente não possui prontuário aberto

---

## Sprint 3 — Agendamentos e Planos

---

### US-11 — Cadastro de agendamento avulso

> *Como administrador ou recepcionista, quero agendar uma sessão avulsa para um paciente, para registrar o atendimento no sistema.*

**Critérios de aceitação:**
- ✅ Sistema aceita os dados: paciente, profissional, tipo de serviço, data, hora início, tipo de atendimento
- ✅ Sistema calcula hora fim automaticamente baseado na duração do tipo de serviço
- ✅ Sistema valida conflito de horário do profissional
- ✅ Sistema valida se profissional está disponível no dia e horário selecionado
- ✅ Status inicial do agendamento é AGENDADO
- ✅ Para atendimento externo, sistema utiliza o endereço cadastrado do paciente
- 🔒 Apenas Administrador e Recepcionista criam agendamentos
- ❌ Sistema exibe erro se profissional já possui agendamento no horário
- ❌ Sistema exibe erro se profissional não possui disponibilidade no horário
- ❌ Sistema exibe erro se paciente não possui endereço cadastrado para atendimento externo

---

### US-12 — Agendamento de turma de Pilates

> *Como administrador ou recepcionista, quero agendar uma sessão de Pilates em turma, para registrar múltiplos pacientes no mesmo horário.*

**Critérios de aceitação:**
- ✅ Sistema permite adicionar múltiplos pacientes na mesma sessão de Pilates
- ✅ Sistema respeita o limite máximo de 6 pacientes por turma
- ✅ Sistema exibe vagas disponíveis na turma
- ✅ Sistema valida conflito de horário do profissional
- 🔒 Apenas Administrador e Recepcionista criam agendamentos
- ❌ Sistema exibe erro se turma já atingiu capacidade máxima
- ❌ Sistema exibe erro se paciente já está agendado naquele horário

---

### US-13 — Cancelamento de agendamento

> *Como administrador ou recepcionista, quero cancelar um agendamento, para liberar o horário do profissional quando necessário.*

**Critérios de aceitação:**
- ✅ Sistema altera status do agendamento para CANCELADO
- ✅ Sistema libera o horário do profissional automaticamente
- ✅ Se agendamento estava vinculado a pacote, sistema não desconta a sessão
- 🔒 Apenas Administrador e Recepcionista cancelam agendamentos
- ❌ Sistema exibe erro se agendamento já foi realizado
- ❌ Sistema exibe erro se agendamento já foi cancelado

---

### US-14 — Atualização de status do agendamento

> *Como administrador ou recepcionista, quero atualizar o status de um agendamento, para registrar se o paciente compareceu ou faltou.*

**Critérios de aceitação:**
- ✅ Sistema permite alterar status para: CONFIRMADO, REALIZADO ou FALTA
- ✅ Quando marcado como REALIZADO e vinculado a pacote, sistema incrementa sessões utilizadas
- ✅ Sistema registra data e hora da atualização
- 🔒 Apenas Administrador e Recepcionista atualizam status
- ❌ Sistema exibe erro se transição de status for inválida (ex: CANCELADO → REALIZADO)

---

### US-15 — Cadastro de plano de Pilates

> *Como administrador, quero cadastrar os planos de Pilates com seus valores, para que possam ser oferecidos aos pacientes.*

**Critérios de aceitação:**
- ✅ Sistema cadastra as 6 combinações: Mensal 2x, Mensal 3x, Trimestral 2x, Trimestral 3x, Semestral 2x, Semestral 3x
- ✅ Sistema registra o valor vigente com data de início
- ✅ Sistema preserva histórico de preços anteriores ao atualizar valor
- ✅ Apenas um preço pode estar ativo por plano por vez
- 🔒 Apenas Administrador acessa essa funcionalidade
- ❌ Sistema exibe erro se já existir plano com mesmo nome e duração

---

### US-16 — Contratação de pacote de sessões

> *Como administrador ou recepcionista, quero registrar a contratação de um pacote de sessões para um paciente, para controlar o saldo de sessões disponíveis.*

**Critérios de aceitação:**
- ✅ Sistema vincula pacote ao paciente e ao plano selecionado
- ✅ Sistema registra o preço vigente no momento da contratação
- ✅ Sistema calcula automaticamente o total de sessões e a data fim
- ✅ Sistema exibe saldo de sessões restantes
- 🔒 Apenas Administrador e Recepcionista contratam pacotes
- ❌ Sistema exibe erro se paciente já possui pacote ativo do mesmo plano

---

### US-17 — Vinculação de agendamento a pacote

> *Como administrador ou recepcionista, quero vincular um agendamento a um pacote de sessões ativo, para descontar automaticamente do saldo do paciente.*

**Critérios de aceitação:**
- ✅ Sistema lista apenas pacotes ativos do paciente com saldo disponível
- ✅ Sistema desconta 1 sessão do pacote quando agendamento for marcado como REALIZADO
- ✅ Sistema exibe saldo atualizado após o agendamento
- ✅ Sistema alerta quando pacote estiver com poucas sessões restantes (menos de 2)
- 🔒 Apenas Administrador e Recepcionista vinculam agendamentos a pacotes
- ❌ Sistema exibe erro se pacote não possui sessões disponíveis

---

## Resumo por sprint

| Sprint | US | Título |
|---|---|---|
| Sprint 1 | US-01 | Login no sistema |
| Sprint 1 | US-02 | Cadastro de profissional |
| Sprint 1 | US-03 | Cadastro de paciente |
| Sprint 1 | US-04 | Cadastro de tipo de serviço |
| Sprint 2 | US-05 | Editar profissional |
| Sprint 2 | US-06 | Editar paciente |
| Sprint 2 | US-07 | Cadastro de disponibilidade do profissional |
| Sprint 2 | US-08 | Visualizar agenda própria |
| Sprint 2 | US-09 | Abertura de prontuário |
| Sprint 2 | US-10 | Registro de evolução clínica |
| Sprint 3 | US-11 | Cadastro de agendamento avulso |
| Sprint 3 | US-12 | Agendamento de turma de Pilates |
| Sprint 3 | US-13 | Cancelamento de agendamento |
| Sprint 3 | US-14 | Atualização de status do agendamento |
| Sprint 3 | US-15 | Cadastro de plano de Pilates |
| Sprint 3 | US-16 | Contratação de pacote de sessões |
| Sprint 3 | US-17 | Vinculação de agendamento a pacote |

---

> **Total: 17 User Stories distribuídas em 3 sprints.**
> Sprint 0 não possui User Stories — é dedicado ao setup técnico do projeto.
