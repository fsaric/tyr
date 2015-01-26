#ifndef VALHALLA_TYR_ROUTE_HANDLER_H_
#define VALHALLA_TYR_ROUTE_HANDLER_H_

#include <valhalla/tyr/handler.h>
#include <valhalla/thor/dynamiccost.h>
#include <valhalla/baldr/graphreader.h>
#include <string>
#include <memory>

namespace valhalla{
namespace tyr{

class RouteHandler : public Handler {
 public:
  /**
   * Parses json request data to be used as options for the action
   *
   * @param config   where the config file resides
   * @param dict     the request data
   * @return a handler object ready to act
   */
  RouteHandler(const std::string& config, const boost::python::dict& dict_request);

  /**
   * Don't expose the default constructor
   */
  RouteHandler() = delete;

  /**
   * Destructor
   */
  virtual ~RouteHandler();

  /**
   * Actually run the route and return the json representation
   * @return string the json representation of the route mirroring the format of OSRM for now
   */
  virtual std::string Action();

 protected:

  valhalla::thor::cost_ptr_t cost_;
  std::unique_ptr<valhalla::baldr::GraphReader> reader_;
};

}
}

#endif  // VALHALLA_TYR_ROUTE_HANDLER_H_