CREATE TABLE users
(
    id         BIGSERIAL PRIMARY KEY,
    name       VARCHAR(150)        NOT NULL,
    phone      VARCHAR(20),
    email      VARCHAR(150) UNIQUE NOT NULL,
    password   VARCHAR(255)        NOT NULL,
    role       VARCHAR(20)         NOT NULL, -- 'ADMIN' or 'EMPLOYEE'
    active     BOOLEAN                      DEFAULT TRUE NOT NULL,
    created_at TIMESTAMP           NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP           NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE customers
(
    id           BIGSERIAL PRIMARY KEY,
    name         VARCHAR(150)   NOT NULL,
    phone        VARCHAR(20)    NOT NULL,
    address      VARCHAR(255),
    credit_limit DECIMAL(10, 2) NOT NULL,
    created_at   TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at   TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE categories
(
    id          BIGSERIAL PRIMARY KEY,
    name        VARCHAR(150) UNIQUE NOT NULL,
    description VARCHAR(200),
    created_at  TIMESTAMP           NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP           NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE products
(
    id            BIGSERIAL PRIMARY KEY,
    name          VARCHAR(150)                   NOT NULL,
    category_id   INT REFERENCES categories (id) NOT NULL,
    price         DECIMAL(10, 2)                 NOT NULL,
    stock         INTEGER                        NOT NULL,
    minimum_stock INTEGER                        NOT NULL,
    active        BOOLEAN                                 DEFAULT TRUE NOT NULL,
    created_at    TIMESTAMP                      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP                      NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE sales
(
    id            BIGSERIAL PRIMARY KEY,
    customer_id   INT REFERENCES customers (id) NOT NULL,
    registered_by INT REFERENCES users (id)     NOT NULL, -- Quem fez a venda
    value_total   DECIMAL(10, 2)                NOT NULL,
    due_date      DATE                          NOT NULL,
    status        VARCHAR(50)                   NOT NULL DEFAULT 'ACTIVE',
    created_at    TIMESTAMP                     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP                     NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE sales_items
(
    id         BIGSERIAL PRIMARY KEY,
    sale_id    INT REFERENCES sales (id)    NOT NULL,
    product_id INT REFERENCES products (id) NOT NULL,
    unit_price DECIMAL(10, 2)               NOT NULL,
    quantity   INTEGER                      NOT NULL
);

CREATE TABLE payments
(
    id             BIGSERIAL PRIMARY KEY,
    sale_id        INT REFERENCES sales (id) NOT NULL,
    received_by    INT REFERENCES users (id) NOT NULL, -- Quem recebeu
    amount         DECIMAL(10, 2)            NOT NULL,
    payment_method VARCHAR(50)               NOT NULL,
    payment_date   TIMESTAMP                 NOT NULL,
    created_at     TIMESTAMP                 NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at     TIMESTAMP                 NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE profiles
(
    id           BIGSERIAL PRIMARY KEY,
    user_id      INT          NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    cpf          VARCHAR(14) UNIQUE,
    cnpj         VARCHAR(18) UNIQUE,
    store_name   VARCHAR(150) NOT NULL,
    address      VARCHAR(255),
    number       VARCHAR(10),
    neighborhood VARCHAR(100),
    city         VARCHAR(100),
    state        VARCHAR(2),
    zip_code     VARCHAR(10),
    segment      VARCHAR(50),
    CONSTRAINT chk_cpf_or_cnpj CHECK ( cpf IS NOT NULL OR cnpj IS NOT NULL ),
    created_at   TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at   TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE code_cancel
(
    id         BIGSERIAL PRIMARY KEY,
    code       VARCHAR(50) UNIQUE        NOT NULL,
    created_by INT REFERENCES users (id) NOT NULL,
    created_at TIMESTAMP                 NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP                 NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_users_role ON users (role);
CREATE INDEX idx_users_active ON users (active);

CREATE INDEX idx_customers_name ON customers (name);

CREATE INDEX idx_categories_name ON categories (name);

CREATE INDEX idx_products_category_id ON products (category_id);
CREATE INDEX idx_products_active ON products (active);

CREATE INDEX idx_sales_customer_id ON sales (customer_id);
CREATE INDEX idx_sales_registered_by ON sales (registered_by);
CREATE INDEX idx_sales_status ON sales (status);
CREATE INDEX idx_sales_due_date ON sales (due_date);
CREATE INDEX idx_sales_created_at ON sales (created_at);
CREATE INDEX idx_sales_status_due_date ON sales (status, due_date);

CREATE INDEX idx_sales_items_sale_id ON sales_items (sale_id);
CREATE INDEX idx_sales_items_product_id ON sales_items (product_id);

CREATE INDEX idx_payments_sale_id ON payments (sale_id);
CREATE INDEX idx_payments_received_by ON payments (received_by);
CREATE INDEX idx_payments_payment_method ON payments (payment_method);