CREATE TABLE usuario (
                         id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
                         nome VARCHAR (100) NOT NULL,
                         email VARCHAR (100) NOT NULL,
                         senha VARCHAR (255) NOT NULL,
                         perfil VARCHAR (20) NOT NULL,
                         ativo BOOLEAN NOT NULL DEFAULT TRUE,
                         data_cadastro TIMESTAMP NOT NULL DEFAULT NOW()
);