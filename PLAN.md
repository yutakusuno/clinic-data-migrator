# Plan

## Database Schema

```mermaid
erDiagram
    patients {
        integer id PK
        string first_name
        string last_name
        string middle_name
        string phone_number
        string email
        date date_of_birth
        string sex
    }
    addresses {
        integer id PK
        integer patient_id FK
        string address_1
        string address_2
        string province
        string city
        string postal_code
    }
    health_identifiers {
        integer id PK
        integer patient_id FK
        string identifier_number
        string province_of_origin
    }
    vitals {
        integer id PK
        integer patient_id FK
        string vital_type
        float measurement
        string units
    }
    file_migrations {
        integer id PK
        string file_name
        datetime start_time
        datetime end_time
        integer imported_count
        text migration_errors
    }

    patients ||--o{ vitals : "has many"
    patients ||--o{ addresses : "has many"
    patients ||--|{ health_identifiers : "has many"
```

### patients

| Field Name    | Nullable | Default Value | Reason                                               |
| ------------- | -------- | ------------- | ---------------------------------------------------- |
| id            | false    | \-            | Primary key, unique identifier                       |
| first_name    | false    | \-            | Essential for patient identification                 |
| last_name     | false    | \-            | Essential for patient identification                 |
| middle_name   | true     | null          | Middle name is not mandatory                         |
| phone_number  | false    | \-            | Required for regular follow-ups                      |
| email         | true     | \-            | Some patients, especially elderly, may not use email |
| date_of_birth | false    | \-            | Important for medical information                    |
| sex           | false    | \-            | Important for medical information                    |

### addresses

| Field Name  | Nullable | Default Value | Reason                                                 |
| ----------- | -------- | ------------- | ------------------------------------------------------ |
| id          | false    | \-            | Primary key, unique identifier                         |
| patient_id  | false    | \-            | Foreign key, necessary for patient association         |
| address_1   | true     | null          | Flexibility for multiple locations and online services |
| address_2   | true     | null          | Supplementary address information                      |
| province    | true     | null          | Flexibility for multiple locations and online services |
| city        | true     | null          | Flexibility for multiple locations and online services |
| postal_code | true     | null          | Flexibility for multiple locations and online services |

### health_identifiers

| Field Name         | Nullable | Default Value | Reason                                             |
| ------------------ | -------- | ------------- | -------------------------------------------------- |
| id                 | false    | \-            | Primary key, unique identifier                     |
| patient_id         | false    | \-            | Foreign key, necessary for patient association     |
| identifier_number  | false    | \-            | Essential health identifier                        |
| province_of_origin | false    | \-            | Necessary for health identifier origin information |

### vitals

| Field Name  | Nullable | Default Value | Reason                                                  |
| ----------- | -------- | ------------- | ------------------------------------------------------- |
| id          | false    | \-            | Primary key, unique identifier                          |
| patient_id  | false    | \-            | Foreign key, necessary for patient association          |
| vital_type  | false    | \-            | Essential for identifying the type of vital information |
| measurement | false    | \-            | Essential measurement value                             |
| units       | false    | \-            | Essential measurement units                             |

### file_migrations

| Field Name       | Nullable | Default Value | Reason                           |
| ---------------- | -------- | ------------- | -------------------------------- |
| id               | false    | \-            | Primary key, unique identifier   |
| file_name        | false    | \-            | Essential file name              |
| start_time       | false    | \-            | Essential migration start time   |
| end_time         | true     | null          | Migration may not be completed   |
| imported_count   | false    | 0             | Initial value set to 0           |
| migration_errors | true     | null          | Errors may not always be present |

## User Story and Data Flow

```mermaid
graph TD
    A[Start CSV Upload] --> B[Read CSV Row by Row]
    B -->|Check if Unique Key Exists in DB| C{Exists?}
    C -->|Yes| D[Skip to Next Row]
    C -->|No| E[Validate Data]
    E --> F{Valid?}
    F -->|Yes| G[Save to Database]
    F -->|No| H[Add Error Message]
    G --> I[Process Next Row]
    H --> I
    I -->|End of CSV| J[Display Results Page]
    J --> K[Show Processed Count, Imported Count, Error Messages]
```

## Migration Details

- Show imported count and error messages
  - To make it easy for users to fix data

## Data Processing

- Use Active Job

  - Pros:
    - Asynchronous processing allows background execution without blocking user interactions.
    - Automatic retries enhance reliability. (Optional)
  - Cons:
    - Potential delays with high job volumes.
    - Complex error handling for frequent job failures.

- Use Transactions

  - Pros:
    - Ensures data integrity by allowing all operations to succeed or fail as a unit.
    - Simplifies error handling with easy rollback.
  - Cons:
    - Long transactions can cause database locks, impacting performance.
    - Complex logic may reduce code readability.

## Future Improvement

- Creating unit/integration tests using auto-testing frameworks like RSpec
- Checking file size when uploading
- Handling System Failures During Transactions
  - Log error details for troubleshooting.
  - Implement mechanisms for resuming or retrying migrations without data loss.
  - Provide user feedback on upload status and errors for data correction.
