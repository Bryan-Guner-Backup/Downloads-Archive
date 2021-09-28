package com.lambdaschool.foundation.config;

import com.lambdaschool.foundation.models.User;
import com.lambdaschool.foundation.repository.UserRepository;
import com.lambdaschool.foundation.services.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.filter.OncePerRequestFilter;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class JwtAuthenticationFilter extends OncePerRequestFilter
{
    // A very specific implementation of userrepos.findByUserName was needed for this filter,
    // so the repository is used directly.
    @Autowired
    UserRepository userrepos;

    // Using the service is preferred so for save, the service is used
    @Autowired
    UserService userService;

    /**
     * A method in this controller adds a new user to the application with the role User so needs access to Role Services to do this.
     */
//    @Autowired
//    private RoleService roleService;

    @Override
    protected void doFilterInternal(
        HttpServletRequest httpServletRequest,
        HttpServletResponse httpServletResponse,
        FilterChain filterChain) throws ServletException, IOException
    {
        // find the username of the authenticated user
        Authentication authentication = SecurityContextHolder.getContext()
            .getAuthentication();

        if (!(authentication instanceof AnonymousAuthenticationToken))
        {
            if (userrepos.findByUsername(authentication.getName()) == null)
            {
                User newUser = new User(authentication.getName());

                // adds a default USER role to this new user
//                Set<UserRoles> newRoles = new HashSet<>();
//                newRoles.add(new UserRoles(newUser,
//                    roleService.findByName("user")));
//                newUser.setRoles(newRoles);

                userService.save(newUser);
            } else
            {
                // we already have this user so nothing to update
            }

            // continue the filter chain.
        } else
        {
            // we do not have a user so nothing to check!
        }
        filterChain.doFilter(httpServletRequest,
            httpServletResponse);
    }
}
