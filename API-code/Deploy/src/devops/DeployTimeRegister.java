package devops;

import javax.ws.rs.Path;
import javax.ws.rs.POST;
import javax.ws.rs.DELETE;
import javax.ws.rs.GET;
import javax.ws.rs.PUT;
import javax.ws.rs.PathParam;
import javax.ws.rs.core.Response;

@Path("/store")
public class DeployTimeRegister {
    @GET
    @Path("/{param}")
    public Response getTime(@PathParam("param") String time) {
        String output = "Deploy time : " + time;
        return Response.status(200).entity(output).build();
    }

    @POST
    @Path("/{param}")
    public Response postTime(@PathParam("param") String time) {
        String output = "Deploy time : " + time;
        return Response.status(200).entity(output).build();
    }

    @POST
    @Path("/post")
    public Response postStrTime( String time) {
        String output = "Add deploy time: " + time;
        return Response.status(200).entity(output).build();
    }

    @PUT
    @Path("/{param}")
    public Response putTime(@PathParam("param") String time) {
        String output = "Update deploy time : " + time;
        return Response.status(200).entity(output).build();
    }

    @DELETE
    @Path("/{param}")
    public Response deleteTime(@PathParam("param") String time) {
        String output = "Remove deploy time : " + time;
        return Response.status(200).entity(output).build();
    }

}