local currentVersion = '1.0.0'

local function fetchLatestVersion(callback)
    PerformHttpRequest('https://api.github.com/repos/RealisticScripts/rs-helmet/releases/latest', function(statusCode, response)
        if statusCode == 200 then
            local data = json.decode(response)
            if data and data.tag_name then
                callback(data.tag_name)
            else
                print('[rs-helmet] Failed to fetch the latest version')
            end
        else
            print(('[rs-helmet] HTTP request failed with status code: %s'):format(statusCode))
        end
    end, 'GET')
end

local function checkForUpdates()
    fetchLatestVersion(function(latestVersion)
        if currentVersion ~= latestVersion then
            print('[rs-helmet] A new version of the script is available!')
            print(('[rs-helmet] Current version: %s'):format(currentVersion))
            print(('[rs-helmet] Latest version: %s'):format(latestVersion))
            print('[rs-helmet] Please update the script from: https://github.com/RealisticScripts/rs-helmet')
        else
            print('[rs-helmet] Your script is up to date!')
        end
    end)
end

checkForUpdates()
