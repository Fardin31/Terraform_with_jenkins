pipeline {
    agent any

    environment {
        TF_PLUGIN_CACHE_DIR = '.terraform.d/plugin-cache'
    }

    stages {
        stage('Terraform Prompt') {
            steps {
                script {
                    // Check if Terraform is initialized
                    def terraformInitialized = fileExists('.terraform')

                    // If not initialized, perform initialization and cache plugins
                    if (!terraformInitialized) {
                        withTerraformCache(cacheID: 'terraform-cache') {
                            // Move withCredentials inside withTerraformCache
                            withCredentials([[
                                $class: 'AmazonWebServicesCredentialsBinding',
                                accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                                credentialsId: 'AWS_CRED',
                                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                            ]]) {
                                sh "terraform init -plugin-dir=${TF_PLUGIN_CACHE_DIR}"
                            }
                        }
                        // Mark Terraform as initialized
                        writeFile file: '.terraform', text: ''
                    }

                    def userInput = input(
                        id: 'terraform-action',
                        message: 'Do you want to apply or destroy Terraform infrastructure?',
                        parameters: [
                            choice(choices: ['apply', 'destroy'], description: 'Select an action')
                        ]
                    )

                    // Execute Terraform based on user input
                    if (userInput == 'apply') {
                        sh 'terraform apply -auto-approve'
                    } else if (userInput == 'destroy') {
                        sh 'terraform destroy -auto-approve'
                    }
                }
            }
        }
    }

    post {
        always {
            // Remove .terraform directory after Terraform commands
            deleteDir()
        }
    }
}

