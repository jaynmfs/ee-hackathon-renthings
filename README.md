# EE-Hackathon-Renthings

## Prerequisites

1. Node.js 16.x.x (via nvm recommended)
2. Visual Studio Code + Extensions

## Setup

1. Create .env or .env.<chian_name>

    ```sh
    cp .env.example .env.<chain_name>
    ```

2. Replace each env with your config

## Start Local Hardhat HTTP and WebSocket JSON-RPC server

```sh
npx hardhat node
```

## Testing

```sh
npx hardhat test
```

## Run script to deploy, setup, read or write

```sh
npx hardhat run scripts/<path_to_script> --network <network_name>
```

## Git Flow

| Branch Name             | Description                    | Branch From   |
| :---------------------- | :----------------------------- | :------------ |
| main                    | Primary branch                 | -             |
| uat/<uat_round>         | For user acceptance testing    | develop       |
| releases/<r_version>    | For released version           | develop, uat  |
| develop                 | Primary branch for development | main          |
| modules/<module_name>   | For new modules                | develop       |
| features/<feature_name> | For new features               | develop       |
| bugs/<bug_title>        | Impact bugs                    | develop       |
| hotfix/<hotfix_title>   | No impact                      | main, develop |

## Recommendations

### Visual Studio Code Extensions

1. Strongly Recommended 💪
   1. Better Comments
   2. Code Spell Checker
   3. DotENV
   4. ESLint
   5. Git Graph
   6. GitLens - Git supercharged
   7. indent-rainbow
   8. IntelliCode
   9. npm
   10. npm Intellisense
   11. Prettier - Code formatter
   12. TODO Highlight
   13. Solidity + Hardhat
2. Optional
   1. Markdown All in One
   2. markdownlint
   3. Material Icon Theme
   4. One Dark Pro
   5. Path Intellisense
   6. Todo Tree
   7. Import Cost

## Q/A

- How to preview markdown file (.md)
  - cmd + shift + v (macOS)
  - ctrl + shift + v (Windows)

- How to flatten smart contract

    ```sh
    npx hardhat flatten <path_to_target_contract> > ./flatten/F-<target_contract_name>
    ```

- How to show helps

    ```sh
    npx hardhat help
    ```
