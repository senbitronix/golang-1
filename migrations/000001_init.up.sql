CREATE SCHEMA todoapp;

CREATE TABLE todoapp.users (
    id SERIAL PRIMARY KEY,
    version BIGINT NOT NULL DEFAULT 1,
    full_name VARCHAR(100) NOT NULL CHECK (LENGTH(full_name) BETWEEN 3 AND 100),
    phone_number VARCHAR(15) CHECK (phone_number ~ '^\+[0-9]{10,15}$')
);

CREATE TABLE todoapp.tasks (
    id SERIAL PRIMARY KEY,
    version BIGINT NOT NULL DEFAULT 1,
    title VARCHAR(255) NOT NULL CHECK (LENGTH(title) BETWEEN 1 AND 1000),
    description VARCHAR(1000) CHECK (LENGTH(description) BETWEEN 1 AND 1000),
    completed BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    completed_at TIMESTAMP,
    CHECK (
        (completed = FALSE AND completed_at IS NULL) OR
        (completed = TRUE AND completed_at IS NOT NULL AND completed_at > created_at)
    ),  
    author_id INT NOT NULL REFERENCES todoapp.users(id)
);