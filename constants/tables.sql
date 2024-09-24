CREATE TABLE Person (
    personId VARCHAR(10) NOT NULL UNIQUE,
    fullName VARCHAR(500) NOT NULL,
    image VARCHAR(1000),
    country VARCHAR(2),
    personAddress VARCHAR(255),
    email VARCHAR(255),
    phone VARCHAR(255)
);
CREATE TABLE Currency (
    currencyId INTEGER PRIMARY KEY,
    currencyName VARCHAR(500) NOT NULL,
    isoCode VARCHAR(2),
    currencySymbol VARCHAR(255),
    conversionUnit DOUBLE,
    deletable BOOL
);
CREATE TABLE Debt (
    debtId INTEGER PRIMARY KEY,
    payableIn VARCHAR(1000),
    moneyValue FLOAT NOT NULL,
    currency INTEGER NOT NULL,
    debtName VARCHAR(255) NOT NULL,
    debtDescription VARCHAR(500),
    creditorId INTEGER,
    createdAt BIGINT,
    expiresAt BIGINT,
    FOREIGN KEY (creditorId) REFERENCES Person(personId) ON DELETE SET NULL
);
CREATE TABLE Asset (
    assetId INTEGER PRIMARY KEY,
    currency INTEGER NOT NULL,
    moneyValue FLOAT NOT NULL,
    assetCategory TEXT NOT NULL,
    assetName VARCHAR(255) NOT NULL,
    assetDescription VARCHAR(500),
    createdAt BIGINT,
    expiresAt BIGINT
);
CREATE TABLE PeriodicPayment (
    paymentId INTEGER PRIMARY KEY,
    currency INTEGER NOT NULL,
    moneyValue FLOAT NOT NULL,
    paymentName VARCHAR(255) NOT NULL,
    paymentDescription VARCHAR(500),
    paidEvery TINYINT NOT NULL,
    payDay TINYINT NOT NULL
)