terraform {
  backend "s3" {
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_security_group" "ec2-security-group" {
  name        = var.security_group
  vpc_id      = var.vpc
  description = "allow all internal traffic, ssh, http, https from anywhere"
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = "true"
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "windows_instance_1" {
  instance_type        = var.windows_instance_type
  ami                  = lookup(var.windows_amis, var.aws_region)
  get_password_data    = true
  key_name = var.key_name
  security_groups      = ["${aws_security_group.ec2-security-group.name}"]
  iam_instance_profile = var.iam_role
  associate_public_ip_address = true
  user_data = <<EOF
  <#
.SYNOPSIS
    Simulates an unpatched and misconfigured Windows Server 2016 environment to trigger CSPM or CNAPP detections.

.DESCRIPTION
    Disables built-in Windows security features including Windows Defender, Firewall, TLS hardening, and exploit mitigations.
    Enables legacy features like SMBv1 and weak RDP configuration.
    Intended for lab and testing environments only.

.NOTES
    Author: @adilio + LLM's
    Date: July 2025
    Tested On: Windows Server 2016 (latest AWS AMI)

.WARNING
    Do not run in production. This script weakens system security significantly.

#>

# Disable Windows Defender
Write-Output "❌ Disabling Windows Defender..."
Set-MpPreference -DisableRealtimeMonitoring $true `
                 -DisableIOAVProtection $true `
                 -DisableIntrusionPreventionSystem $true `
                 -EnableControlledFolderAccess Disabled `
                 -DisableScriptScanning $true `
                 -MAPSReporting Disabled `
                 -SubmitSamplesConsent NeverSend

# Enable SMBv1
Write-Output "📡 Enabling insecure SMBv1 protocol..."
Enable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol -NoRestart

# Enable admin shares (C$, ADMIN$)
Write-Output "🔓 Ensuring admin shares are active..."
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" `
                 -Name "AutoShareWks" -Value 1 -PropertyType DWORD -Force

# Disable TLS 1.2
Write-Output "📉 Disabling modern TLS protocols (TLS 1.2)..."
New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2" -Force
New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client" -Force
New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server" -Force
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client" `
                 -Name "Enabled" -Value 0 -PropertyType DWORD -Force
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server" `
                 -Name "Enabled" -Value 0 -PropertyType DWORD -Force

# Enable RDP without NLA
Write-Output "🔐 Disabling RDP Network Level Authentication..."
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" `
                 -Name "UserAuthentication" -Value 0

# Disable Windows Firewall
Write-Output "🧱 Disabling Windows Firewall..."
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
Write-Output "✅ Vulnerable system configuration complete. Reboot may be required to apply all settings."
EOF
}
