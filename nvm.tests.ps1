Import-Module ./nvm.psd1

Describe "Get-NodeVersions" {
    InModuleScope nvm {
        Context "Local versions" {
            It "Gets known versions" {
                $tmpDir = [system.io.path]::GetTempPath()
                Mock Get-NodeInstallLocation { Join-Path $tmpDir '.nvm\settings.json' }
                Mock Test-Path { return $true }
                Mock Get-ChildItem {
                    $ret = @()
                    $ret += @{ Name = 'v8.9.0' }
                    $ret += @{ Name = 'v9.0.0' }
                    return $ret
                }

                $versions = Get-NodeVersions
                $versions.Count | Should -Be 2
                $versions | Should -Be @('v9.0.0'; 'v8.9.0')
            }

            It "Gets known versions with filter" {
                $tmpDir = [system.io.path]::GetTempPath()
                Mock Get-NodeInstallLocation { Join-Path $tmpDir '.nvm\settings.json' }
                Mock Test-Path { return $true }
                Mock Get-ChildItem {
                    $ret = @()
                    $ret += @{ Name = 'v8.9.0' }
                    $ret += @{ Name = 'v9.0.0' }
                    return $ret
                }

                $versions = Get-NodeVersions -Filter 'v8.9.0'
                $versions | Should -Be 'v8.9.0'

            }

            It "Returns nothing when no versions are installed" {
                $tmpDir = [system.io.path]::GetTempPath()
                Mock Get-NodeInstallLocation { Join-Path $tmpDir '.nvm\settings.json' }
                Mock Test-Path { return $false }
                Get-NodeVersions -Filter 'v8.9.0' | Should -BeNullOrEmpty
            }
        }

        Context "Remote versions" {
            It "Will list remote versions" {
                $mockJson = "[
                    {""version"":""v9.0.0"",""date"":""2017-10-31"",""files"":[""aix-ppc64"",""headers"",""linux-arm64"",""linux-armv6l"",""linux-armv7l"",""linux-ppc64le"",""linux-x64"",""linux-x86"",""osx-x64-pkg"",""osx-x64-tar"",""src"",""sunos-x64"",""sunos-x86"",""win-x64-7z"",""win-x64-exe"",""win-x64-msi"",""win-x64-zip"",""win-x86-7z"",""win-x86-exe"",""win-x86-msi"",""win-x86-zip""],""npm"":""5.5.1"",""v8"":""6.2.414.32"",""uv"":""1.15.0"",""zlib"":""1.2.11"",""openssl"":""1.0.2l"",""modules"":""59"",""lts"":false},
                    {""version"":""v8.9.0"",""date"":""2017-10-31"",""files"":[""aix-ppc64"",""headers"",""linux-arm64"",""linux-armv6l"",""linux-armv7l"",""linux-ppc64le"",""linux-x64"",""linux-x86"",""osx-x64-pkg"",""osx-x64-tar"",""src"",""sunos-x64"",""sunos-x86"",""win-x64-7z"",""win-x64-exe"",""win-x64-msi"",""win-x64-zip"",""win-x86-7z"",""win-x86-exe"",""win-x86-msi"",""win-x86-zip""],""npm"":""5.5.1"",""v8"":""6.1.534.46"",""uv"":""1.15.0"",""zlib"":""1.2.11"",""openssl"":""1.0.2l"",""modules"":""57"",""lts"":""Carbon""},
                    {""version"":""v8.8.1"",""date"":""2017-10-25"",""files"":[""aix-ppc64"",""headers"",""linux-arm64"",""linux-armv6l"",""linux-armv7l"",""linux-ppc64le"",""linux-x64"",""linux-x86"",""osx-x64-pkg"",""osx-x64-tar"",""src"",""sunos-x64"",""sunos-x86"",""win-x64-7z"",""win-x64-exe"",""win-x64-msi"",""win-x64-zip"",""win-x86-7z"",""win-x86-exe"",""win-x86-msi"",""win-x86-zip""],""npm"":""5.4.2"",""v8"":""6.1.534.42"",""uv"":""1.15.0"",""zlib"":""1.2.11"",""openssl"":""1.0.2l"",""modules"":""57"",""lts"":false}
                ]"

                Mock Invoke-WebRequest { return $mockJson }

                $versions = Get-NodeVersions -Remote
                $versions.Count | Should -Be 3
            }

            It "Will list remote versions with filter" {
                $mockJson = "[
                    {""version"":""v9.0.0"",""date"":""2017-10-31"",""files"":[""aix-ppc64"",""headers"",""linux-arm64"",""linux-armv6l"",""linux-armv7l"",""linux-ppc64le"",""linux-x64"",""linux-x86"",""osx-x64-pkg"",""osx-x64-tar"",""src"",""sunos-x64"",""sunos-x86"",""win-x64-7z"",""win-x64-exe"",""win-x64-msi"",""win-x64-zip"",""win-x86-7z"",""win-x86-exe"",""win-x86-msi"",""win-x86-zip""],""npm"":""5.5.1"",""v8"":""6.2.414.32"",""uv"":""1.15.0"",""zlib"":""1.2.11"",""openssl"":""1.0.2l"",""modules"":""59"",""lts"":false},
                    {""version"":""v8.9.0"",""date"":""2017-10-31"",""files"":[""aix-ppc64"",""headers"",""linux-arm64"",""linux-armv6l"",""linux-armv7l"",""linux-ppc64le"",""linux-x64"",""linux-x86"",""osx-x64-pkg"",""osx-x64-tar"",""src"",""sunos-x64"",""sunos-x86"",""win-x64-7z"",""win-x64-exe"",""win-x64-msi"",""win-x64-zip"",""win-x86-7z"",""win-x86-exe"",""win-x86-msi"",""win-x86-zip""],""npm"":""5.5.1"",""v8"":""6.1.534.46"",""uv"":""1.15.0"",""zlib"":""1.2.11"",""openssl"":""1.0.2l"",""modules"":""57"",""lts"":""Carbon""},
                    {""version"":""v8.8.1"",""date"":""2017-10-25"",""files"":[""aix-ppc64"",""headers"",""linux-arm64"",""linux-armv6l"",""linux-armv7l"",""linux-ppc64le"",""linux-x64"",""linux-x86"",""osx-x64-pkg"",""osx-x64-tar"",""src"",""sunos-x64"",""sunos-x86"",""win-x64-7z"",""win-x64-exe"",""win-x64-msi"",""win-x64-zip"",""win-x86-7z"",""win-x86-exe"",""win-x86-msi"",""win-x86-zip""],""npm"":""5.4.2"",""v8"":""6.1.534.42"",""uv"":""1.15.0"",""zlib"":""1.2.11"",""openssl"":""1.0.2l"",""modules"":""57"",""lts"":false}
                ]"

                Mock Invoke-WebRequest { return $mockJson }

                $versions = Get-NodeVersions -Remote -Filter "v8"
                $versions.Count | Should -Be 2
            }
        }
    }
}

Describe "Get-NodeInstallLocation" {
    InModuleScope nvm {
        It "Should return the location when it exists" {
            $tmpDir = [system.io.path]::GetTempPath()
            $installPath = Join-Path $tmpDir '.nvm'
            Mock Test-Path { return $true }
            Mock Get-Content { return @{ InstallPath = $installPath } | ConvertTo-Json }

            $location = Get-NodeInstallLocation
            $location | Should -Be $installPath
        }
    }
}

Describe "Install-NodeVersion" {
    InModuleScope nvm {
        Context "Installing with a specific version" {
            It "Install a requested version" -Skip:($env:include_integration_tests -ne $true) {
                Install-NodeVersion -Version 'v9.0.0'

                $versions = Get-NodeVersions -Filter 'v9.0.0'
                $versions | Should -Be 'v9.0.0'
            }

            It "Throws when version already exists" -Skip:($env:include_integration_tests -ne $true) {
                Install-NodeVersion -Version 'v9.0.0'
                { Install-NodeVersion -Version 'v9.0.0' } | Should Throw
            }

            It "Won't throw when version already exists if you use the -Force flag" -Skip:($env:include_integration_tests -ne $true) {
                { Install-NodeVersion -Version 'v9.0.0' -Force } | Should Not Throw
            }

            It "Can install without a 'v' prefix" -Skip:($env:include_integration_tests -ne $true) {
                { Install-NodeVersion -Version '9.0.0' -Force } | Should Not Throw
            }
        }

        Context "Major version installing" {
            It "Can install from just a major version" -Skip:($env:include_integration_tests -ne $true) {
                Install-NodeVersion -Version '9'

                $versions = Get-NodeVersions -Filter 'v9'
                $versions | Should -Match 'v9'
            }
        }

        Context "Major and minor version installing" {
            It "Can install from just a major and minor version" -Skip:($env:include_integration_tests -ne $true) {
                Install-NodeVersion -Version '9.0'

                $versions = Get-NodeVersions -Filter 'v9.0'
                $versions | Should -Match 'v9.0'
            }
        }

        Context "Installing with a keyword" {
            It "Installs under the `latest` flag" -Skip:($env:include_integration_tests -ne $true) {
                Install-NodeVersion -Version 'latest'

                $versions = Get-NodeVersions
                $versions.GetType() | Should -Be 'SemVer.Version'
            }
        }
    }

    BeforeEach {
        $installLocation = Join-Path ([system.io.path]::GetTempPath()) '.nvm'
        Set-NodeInstallLocation -Path $installLocation
    }

    AfterEach {
        Remove-Item -Recurse -Force $installLocation

        $settingsFile = Join-Path $PSScriptRoot 'settings.json'

        if ((Test-Path $settingsFile) -eq $true) {
            Remove-Item -Force $settingsFile
        }
    }
}

Describe "Set-NodeVersion" {
    InModuleScope nvm {
        Context "auto-discovery" {
            $nodeVersion = 'v9.0.0'

            It "Will set from the .nvmrc file" {
                $tmpDir = [system.io.path]::GetTempPath()
                $nvmDir = Join-Path $tmpDir '.nvm'
                Mock Test-Path { return $true } -ParameterFilter { $Path.StartsWith('variable') -eq $false }
                Mock Get-Content -ParameterFilter { $Path -match '\.nvmrc$' } { return $nodeVersion }
                Mock Get-NodeInstallLocation { return $nvmDir }

                Set-NodeVersion -InformationVariable infos
                $infos | Should -Be "Switched to node version $nodeVersion"
            }

            It "Will set from the engines package.json field" {
                $tmpDir = [system.io.path]::GetTempPath()
                Mock Test-Path -ParameterFilter { $Path.StartsWith('variable') -eq $false } {
                    return (-not ($Path -match '\.nvmrc$'))
                }
                Mock Get-Content -ParameterFilter { $Path -match 'package.json$' } {
                    return @{
                        engines = @{
                            node = '^9.0.0'
                        }
                    } | ConvertTo-Json
                }
                Mock Get-NodeVersions { return 'v9.1.0' }
                Mock Get-NodeInstallLocation { return Join-Path $tmpDir '.nvm' }

                Set-NodeVersion -InformationVariable infos
                $infos | Should -Be "Switched to node version v9.1.0"
            }

            It "Will error if no version in the package.json field" {
                Mock Test-Path -ParameterFilter { $Path.StartsWith('variable') -eq $false } {
                    return (-not ($Path -match '\.nvmrc$'))
                }
                Mock Get-Content -ParameterFilter { $Path -match 'package.json$' } {
                    return @{
                        engines = @{
                        }
                    } | ConvertTo-Json
                }

                { Set-NodeVersion } | Should Throw
            }

            It "Will error if no version, no .nvmrc and no package.json" {
                Mock Test-Path -ParameterFilter { $Path.Contains('.nvmrc') } {
                    return $false
                }
                Mock Test-Path { return $false } -ParameterFilter { $Path.Contains('./package.json') }

                { Set-NodeVersion } | Should Throw "Version not given and no .nvmrc or package.json found in folder"
            }
        }

        Context "Set from version string" {
            $nodeVersion = 'v9.0.0'

            It "Will set from the supplied version" {
                Set-NodeVersion $nodeVersion -InformationVariable infos
                $infos | Should -Be "Switched to node version $nodeVersion"
            }

            It "Will set from a version range" {
                Mock Get-NodeVersions { return @('v9.0.0'; 'v8.9.0') }

                Set-NodeVersion 'v9' -InformationVariable infos
                $infos | Should -Be "Switched to node version $nodeVersion"
            }

            It "Will set from a version range with caret" {
                Mock Get-NodeVersions { return @('v9.0.0'; 'v8.9.0') }

                Set-NodeVersion '^9.0.0' -InformationVariable infos
                $infos | Should -Be "Switched to node version $nodeVersion"
            }

            It "Will throw error on unmatched version range" {
                {
                    Mock Get-NodeVersions { return @() }

                    Set-NodeVersion 'v7'
                } | Should -Throw "No version found that matches v7"
            }

            It "Will set npm config path" {
                Mock Get-NodeVersions { return @('v9.0.0') }

                Set-NodeVersion 'v9' -InformationVariable infos
                $env:NPM_CONFIG_GLOBALCONFIG | Should -not -Be $null
            }

            BeforeEach {
                $tmpDir = [system.io.path]::GetTempPath()
                Mock Get-NodeInstallLocation { return Join-Path $tmpDir '.nvm' }
                Mock Test-Path { return $true } -ParameterFilter { $Path.StartsWith((Join-Path $tmpDir '.nvm')) -eq $true }
            }
        }
    }
    AfterEach {
        $settingsFile = Join-Path $PSScriptRoot 'settings.json'

        if ((Test-Path $settingsFile) -eq $true) {
            Remove-Item -Force $settingsFile
        }
    }
}

Describe "Remove-NodeVersion" {
    InModuleScope nvm {
        It "Should remove a version" {
            $tmpDir = [system.io.path]::GetTempPath()
            Mock Get-NodeInstallLocation { return $tmpDir }
            Mock Test-Path { return $true }
            Mock Remove-Item { }

            Remove-NodeVersion 'v9.0.0'

            Assert-MockCalled -CommandName Remove-Item -Times 1 -ParameterFilter { $Path -eq (Join-Path $tmpDir 'v9.0.0') }
        }

        It "Should throw when version doesn't exist" {
            $tmpDir = [system.io.path]::GetTempPath()
            Mock Get-NodeInstallLocation { return $tmpDir }
            Mock Test-Path { return $false }
            Mock Remove-Item { }

            $version = 'v9.0.0'
            { Remove-NodeVersion $version } | Should -Throw "Could not find node version $version"
        }
    }
}
