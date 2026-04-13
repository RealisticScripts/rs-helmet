local currentVersion = 'v1.0.0'
local repoName = 'rs-helmet' -- change per script

local function fetchLatestVersion(callback)
    local url = ('https://api.github.com/repos/RealisticScripts/%s/releases/latest'):format(repoName)

    local headers = {
        ['User-Agent'] = ('%s-version-check'):format(repoName),
        ['Accept'] = 'application/vnd.github+json'
    }

    PerformHttpRequest(url, function(statusCode, response, responseHeaders)
        if statusCode == 200 then
            local data = json.decode(response)
            if data and data.tag_name then
                callback(data.tag_name)
            else
                print(('[%s] Failed to parse latest release data'):format(repoName))
            end
        elseif statusCode == 403 then
            print(('[%s] GitHub API returned 403. Likely rate-limited.'):format(repoName))
            if response then
                print(('[%s] Response: %s'):format(repoName, response))
            end
        elseif statusCode == 404 then
            print(('[%s] Release endpoint not found. Check repo name or whether a release exists.'):format(repoName))
        else
            print(('[%s] HTTP request failed with status code: %s'):format(repoName, statusCode))
            if response then
                print(('[%s] Response: %s'):format(repoName, response))
            end
        end
    end, 'GET', '', headers)
end

local function checkForUpdates()
    fetchLatestVersion(function(latestVersion)
        if currentVersion ~= latestVersion then
            print(('[%s] A new version is available!'):format(repoName))
            print(('[%s] Current version: %s'):format(repoName, currentVersion))
            print(('[%s] Latest version: %s'):format(repoName, latestVersion))
            print(('[%s] Update here: https://github.com/RealisticScripts/%s'):format(repoName, repoName))
        else
            print(('[%s] Your script is up to date!'):format(repoName))
        end
    end)
end

CreateThread(function()
    Wait(math.random(5000, 20000)) -- stagger requests to reduce rate-limit hits
    checkForUpdates()
end)
