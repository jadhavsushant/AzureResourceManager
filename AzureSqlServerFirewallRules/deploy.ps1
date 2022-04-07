$parameters1 = Get-Content "D:\AzureResourceManager\AzureResourceManager\AzureSqlServerFirewallRules\parameters.json" | ConvertFrom-json

$TemplateFile = "D:\AzureResourceManager\AzureResourceManager\AzureSqlServerFirewallRules\armtemplate.json"

$dbname = $parameters1.WorkLoads[0].DbName
$DbType = $parameters1.WorkLoads[0].DbType
$firewallIps = @()
$firewallRule = $parameters1.WorkLoads[0].firewallRuleName | ForEach-Object {
    @{'name' = [string]$_.FirewallRuleName; 'startIpAddress' = [string]$_.startIpAddress; 'endIpAddress' = [string]$_.endIpAddress }
}
$firewallIps += $firewallRule
$deployments = @{}
$deployments.Add('DbName', $dbname)
$deployments.Add('DbType', $DbType)
$deployments.Add('firewallRuleName', $firewallIps)

$armDeploymentsets = $deployments

New-AzResourceGroupDeployment -Name "localDeployment" -ResourceGroupName "azresourcegroup" -TemplateFile $TemplateFile -TemplateParameterObject $armDeploymentsets -Force -Verbose