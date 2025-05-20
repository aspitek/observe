function parse_log(tag, timestamp, record)
    local new_record = {}
    -- Si le log est déjà structuré (par ex. Kubernetes JSON), conserver
    if record.time and record.log then
        new_record = record
    else
        -- Sinon, utiliser le champ 'log' du parser générique et ajouter un timestamp
        new_record.time = os.date("%Y-%m-%dT%H:%M:%S")
        new_record.log = record.log or table.concat(record, " ")
    end
    return 1, timestamp, new_record
end