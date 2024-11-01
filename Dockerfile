# Use a PowerShell base image
FROM mcr.microsoft.com/powershell:latest

# Install cron
RUN apt-get update && apt-get install -y cron

# Set up a directory for the script
#WORKDIR /app

# Copy your PowerShell script into the container
COPY bot.ps1 /bot.ps1

# Create a cron job to run the PowerShell script every day at midnight
#RUN echo "* * * * * pwsh -File bot.ps1" > /etc/cron.d/powershell-cron
# Create a cron job to run the PowerShell script every minute, redirecting output to Docker logs
RUN echo "* * * * * pwsh -File /bot.ps1 > /proc/1/fd/1 2>/proc/1/fd/2" > /etc/cron.d/powershell-cron

# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/powershell-cron

# Apply the cron job
RUN crontab /etc/cron.d/powershell-cron

# Run the cron service in the foreground
CMD ["cron", "-f"]