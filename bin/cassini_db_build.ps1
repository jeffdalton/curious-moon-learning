Write-Host "Start $($MyInvocation.MyCommand.Name) @ $(Get-Date)"

function Build-Import-Script($import_template, $import_file, $build_file)
{
	Write-Output "Import Template $import_template"
	Write-Output "Import File $import_file"
	Write-Output "Build File $build_file"
	(Get-Content $import_template).Replace('[IMPORT_FILE]', $import_file) | 
	Add-Content $build_file
}

function Build-Normalize-Script($tables_list, $drop_template, $lookup_template, $normalize_template, $build_file)
{
	ForEach($item in $tables_list) {
		$table = $item.table
		$column = $item.column
		Write-Host "Table: $table   Column: $column"
		(Get-Content $drop_template).Replace('[TABLE]', $table) | Add-Content $build_file
	}

	ForEach($item in $tables_list) {
		if ($item.isLookup) {
			$table = $item.table
			$column = $item.column
			(Get-Content $lookup_template).Replace('[TABLE]', $table).Replace('[COLUMN]', $column) |
				Add-Content $build_file
		}
	}

	Get-Content $normalize_template | Add-Content $build_file

}

function Build-Enceladus-Events-Script $enceladus_events_file $build_file
{
	Get-Content $enceladus_events_file | Add-Content $build_file
}

$config=Get-Content -Path config/cassini_db_build.json -Raw | ConvertFrom-Json

# Prepare build settings
$db = $config.db
$base_dir = (Get-Location).ToString() + "/"
$build_dir = $base_dir + $config.build_dir
$drop_template = $base_dir + $config.template_dir + $config.drop_template
$lookup_template = $base_dir + $config.template_dir + $config.lookup_template
$import_template = $base_dir + $config.template_dir + $config.import_template
$normalize_template = $base_dir + $config.template_dir + $config.normalize_template
$import_file = $base_dir + $config.import_file
$build_file = $build_dir + $config.build_file
$events_enceladus_file = $base_dir + $config.script_dir + $config.enceladus_events_file
Write-Host "Target Database ${db}"

if (Test-Path -Path $build_dir)
{
	Remove-Item $build_dir -Force -Recurse 
}
New-Item -ItemType Directory -Force -Path $build_dir
Build-Import-Script $import_template $import_file $build_file
Build-Normalize-Script $config.normalize_tables $drop_template $lookup_template $normalize_template $build_file
Build-Enceladus-Events-Script $enceladus_events_file $build_file
psql $db -f $build_file
if (!$?) {
	Write-Output "Error End $($MyInvocation.MyCommand.Name) @ $(Get-Date)"
	exit
}


Write-Host "Normal End $($MyInvocation.MyCommand.Name) @ $(Get-Date)"
