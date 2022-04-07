$parameters1 = Get-Content "C:\script\arm\SQL-FirewallRule\parameters.json" | ConvertFrom-json

$TemplateFile = "C:\script\arm\SQL-FirewallRule\armtemplate.json"

$dbname = $parameters1.WorkLoads[0].DbName
$firewallIps = @()
$firewallRule = $parameters1.WorkLoads[0].firewallRuleName | ForEach-Object {
    @{'name' = [string]$_.FirewallRuleName; 'startIpAddress' = [string]$_.startIpAddress; 'endIpAddress' = [string]$_.endIpAddress }
}
$firewallIps += $firewallRule
$deployments = @{}
$deployments.Add('DbName', $dbname)
$deployments.Add('firewallRuleName', $firewallIps)

$armDeploymentsets = $deployments

New-AzResourceGroupDeployment -Name "localDeployment" -ResourceGroupName "azresourcegroup" -TemplateFile $TemplateFile -TemplateParameterObject $armDeploymentsets -Force -Verbose