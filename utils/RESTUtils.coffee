#
#  Very basic CRUD route creation utility for models.
#  For validation, simply override the model's save method.
#

errMsg = (msg) ->
    return error:
        message: msg.toString()

# ------------------------------
#  List
#
exports.getListController = (model) ->
    (req, res) ->
        model.find {_company: req.user._company}, (err, result) ->
            if not err
                res.send result
            else
                res.send (errMsg err)

#------------------------------
# Create
#
exports.getCreateController = (model) ->
    return (req, res) ->
        m = new model req.body
        m._company = req.user._company
        m.save (err) ->
            if not err
                res.send m
            else
                res.send (errMsg err)

#------------------------------
# Read
#
exports.getReadController = (model) ->
    return (req, res) ->
        model.findById req.params.id, (err, result) ->
            if not err
                res.send result
            else
                res.send (errMsg err)

#------------------------------
# Update
#
exports.getUpdateController = (model) ->
    return (req, res) ->
        model.findById req.params.id, (err, result) ->
            for key, value of req.body
                result[key] = value

            result.save (err) ->
                if not err
                    res.send result
                else
                    res.send (errMsg err)

#------------------------------
# Delete
#
exports.getDeleteController = (model) ->
    return (req, res) ->
        model.findById req.params.id, (err, result) ->
            if err
                res.send (errMsg err)
            else
                result.remove()
                result.save (err) ->
                    if not err
                        res.send {}
                    else
                        res.send (errMsg err)
