FROM node:18

WORKDIR /app

# Copy dependency files
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install

# Copy all project files
COPY . .

# Compile contracts (IMPORTANT)
RUN npx hardhat compile

# Run tests
CMD ["npx", "hardhat", "test"]
