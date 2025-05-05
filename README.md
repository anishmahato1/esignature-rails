# eSignature Rails API

A Rails-based API for electronic document signing with a streamlined one-step signing process.

## Features

- User authentication with JWT
- Document upload and management
- Signature upload and management
- One-step electronic signatures with automatic PDF embedding
- PDF manipulation with HexaPDF


## Setup

### Prerequisites

- Docker and Docker Compose

### Installation and Setup

1. Clone the repository
2. Create your environment file:

```bash
cp .env.example .env
```

3. Build the Docker containers:

```bash
docker compose build
```

4. Start the services:

```bash
docker compose up
```

## Document Signing Process

The application implements a streamlined document signing process:

1. **Upload Document**: Users upload PDF documents to be signed (status: `pending`)
2. **Upload Signature**: Users upload a signature image
3. **Place Signature**: Users select a signature and place it on the document
4. **Automatic Embedding**: Based on the signature placement position, the signature is embedded into the PDF (status: `signed`)
5. **Download Signed Document**: Users can download the signed document

If any errors occur during the signature application process, the document is marked as `failed` and can be retried.

**Note:** Signatures cannot be updated once they are placed on a document. If you need to change a signature's position, you'll need to delete the document and re-upload it.


## API Documentation

### Authentication

- `POST /api/v1/signup` - Register a new user
- `POST /api/v1/login` - Login and receive a JWT token

### Documents

- `GET /api/v1/documents` - List all documents
- `GET /api/v1/documents/:id` - View a document
- `POST /api/v1/documents` - Create a document
- `DELETE /api/v1/documents/:id` - Delete a document
- `GET /api/v1/documents/:id/download_signed` - Download a signed document

### Signatures

- `GET /api/v1/signatures` - List all user signatures
- `POST /api/v1/signatures` - Create a signature
- `GET /api/v1/signatures/:id` - View a signature
- `PUT /api/v1/signatures/:id` - Update a signature
- `DELETE /api/v1/signatures/:id` - Delete a signature

### Document Signing

- `POST /api/v1/documents/:document_id/sign_document`


## Postman Collection
- [Download Postman Collection](https://www.postman.com/the-odyssey-33845490-0000-4000-8000-000000000000/workspace/the-odyssey/collection/23928742-23928742-23928742-23928742)